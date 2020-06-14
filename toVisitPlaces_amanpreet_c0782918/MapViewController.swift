//
//  ViewController.swift
//  toVisitPlaces_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-14.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var destinationCoordinates : CLLocationCoordinate2D!
    let destCoordinate = MKDirections.Request()
       
    var places:[Places]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.isZoomEnabled = false
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
               tap.numberOfTapsRequired = 2
               mapView.addGestureRecognizer(tap)
        loadData()
    }
    
    func getDataFilePath() -> String {
           let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
           let filePath = documentPath.appending("/places-data.txt")
           return filePath
       }
    
    func loadData() {
        places = [Places]()
        
        let filePath = getDataFilePath()
        
        if FileManager.default.fileExists(atPath: filePath){
            do{
                //creating string of file path
             let fileContent = try String(contentsOfFile: filePath)
                //separating books from each other
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray{
                    //separating each book's content
                    let placeContent = content.components(separatedBy: ",")
                    if placeContent.count == 4 {
                        let place = Places(latitude: destinationCoordinates.latitude, longitude: destinationCoordinates.longitude)
                        places?.append(place)
                    }
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let placeListVC = segue.destination as? PlacesTableViewController{
             placeListVC.places = self.places
         }
     }
     
    @objc func saveData() {
         let filePath = getDataFilePath()

         var saveString = ""
         for place in places!{
            saveString = "\(saveString)\(place.latitude) \(place.longitude) \n"
             do{
            try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
             }
             catch{
                 print(error)
             }
         }
     }
    
     @objc func handleTap(recognizer: UITapGestureRecognizer) {
            
           let mapAnnotations  = self.mapView.annotations
           self.mapView.removeAnnotations(mapAnnotations)
           let tapLocation = recognizer.location(in: mapView)
           self.destinationCoordinates = mapView.convert(tapLocation, toCoordinateFrom: mapView)
               
               
               if recognizer.state == .ended
               {
                   
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = self.destinationCoordinates!
                    annotation.title = "Your destination"
                    self.mapView.addAnnotation(annotation)
               }
           }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
               let userLocation = locations[0]
               
               let latitude = userLocation.coordinate.latitude
               let longitude = userLocation.coordinate.longitude
                
               let latDelta: CLLocationDegrees = 0.05
               let longDelta: CLLocationDegrees = 0.05
                
                // 3 - Creating the span, location coordinate and region
               let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
               let customLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
               let region = MKCoordinateRegion(center: customLocation, span: span)
                      
                // 4 - assign region to map
               mapView.setRegion(region, animated: true)
            }

    @IBAction func locationBtn(_ sender: UIButton) {
         getRoute()
    }
    
    
       func getRoute() {
          
                  let sourceCoordinate = mapView.userLocation.coordinate
                  
                  let source = CLLocationCoordinate2DMake(sourceCoordinate.latitude, sourceCoordinate.longitude)
                  let destination = CLLocationCoordinate2DMake(self.destinationCoordinates?.latitude ?? 0, self.destinationCoordinates?.longitude ?? 0)
                  
                  let sourcePlacemark = MKPlacemark(coordinate: source)
                  let destPlacemark = MKPlacemark(coordinate: destination)
           
                    destCoordinate.transportType = .automobile
                              for overlay in mapView.overlays{
                                  mapView.removeOverlay(overlay)
                                }
                       
                    
           destCoordinate.source = MKMapItem(placemark: sourcePlacemark)
           destCoordinate.destination =  MKMapItem(placemark: destPlacemark)
           
           
           let direction = MKDirections(request: destCoordinate)
           direction.calculate{
               (response, error) in
                  guard let locResponse = response else{
                             if let error = error{
                                 print(error)
                             }
                             return
                       }
                   for route in locResponse.routes{
                          self.mapView.addOverlay(route.polyline,level:.aboveRoads)
                          self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                      }
                     
                  }
       }
    
//    func geocode()  {
//        CLGeocoder().reverseGeocodeLocation() { placemark, error in
//            guard let placemark = placemark, error == nil else {
//                completion(nil, error)
//                return
//            }
//            completion(placemark, nil)
//        }
//    }
}

extension MapViewController {
    
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    
            if annotation is MKUserLocation {
                return nil
            }
    
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
                pinAnnotation.animatesDrop = true
                pinAnnotation.pinTintColor = .orange
                pinAnnotation.canShowCallout = true
                pinAnnotation.rightCalloutAccessoryView = UIButton(type: .contactAdd)
    
                return pinAnnotation
    
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
         let alertController = UIAlertController(title: "Add to Favourites", message:
                       "Do you want to add marked Location to favourites?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style:  .default, handler: { (UIAlertAction) in
//            geocode(latitude: <#T##Double#>, longitude: <#T##Double#>, completion: <#T##([CLPlacemark]?, Error?) -> Void#>)
        }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.present(alertController, animated: true, completion: nil)
                    
    }

func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 5.0
            return renderer
     }
}


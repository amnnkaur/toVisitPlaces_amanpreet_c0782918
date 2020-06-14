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
}

extension MapViewController {

func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor.systemTeal
            renderer.lineWidth = 5.0
            return renderer
     }
}


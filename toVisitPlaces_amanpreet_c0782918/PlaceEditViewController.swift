//
//  PlaceEditViewController.swift
//  toVisitPlaces_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-15.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import UIKit
import MapKit

class PlaceEditViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var editMap: MKMapView!
    let defaults = UserDefaults.standard
       var lat : Double = 0.0
       var long : Double = 0.0
       var drag : Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editMap.delegate = self
                
        self.editMap.addAnnotation(dragablePin())
    
    }
    
   func dragablePin() -> MKPointAnnotation{
    self.lat = defaults.double(forKey: "latitude")
    self.long = defaults.double(forKey: "longitude")
    
    self.drag = defaults.bool(forKey: "bool")
    
    print("Lat: \(lat): Long: \(long)")
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    annotation.title = "Your destination"
    //        self.mapView.addAnnotation(annotation)
    return annotation
    
    
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
  
        let pinAnnotation = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
                pinAnnotation.markerTintColor = .systemPink
                pinAnnotation.glyphTintColor = .white
                pinAnnotation.isDraggable = true
                pinAnnotation.canShowCallout = true
                return pinAnnotation
    
    }



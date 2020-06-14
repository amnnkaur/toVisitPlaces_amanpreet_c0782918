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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.isZoomEnabled = false
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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

}


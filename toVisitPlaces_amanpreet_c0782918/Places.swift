//
//  Places.swift
//  toVisitPlaces_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-14.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import Foundation

class Places{
    
    var latitude: Double
    var longitude: Double
    var placeName :String
    var city :String
    var postalCode : String
    var country : String
    
    init(latitude:Double , longitude: Double, placeName:String, city:String, postalCode: String, country:String) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
        self.city = city
        self.postalCode = postalCode
        self.country = country
    }
    
    
}

//
//  Places.swift
//  toVisitPlaces_amanpreet_c0782918
//
//  Created by Aman Kaur on 2020-06-14.
//  Copyright © 2020 Aman Kaur. All rights reserved.
//

import Foundation

class Places{
    
    var placeLat: Double
    var placeLong: Double
    var placeName :String
    var city :String
    var postalCode : String
    var country : String
    
    init(placeLat:Double , placeLong: Double, placeName:String, city:String, postalCode: String, country:String) {
        self.placeLat = placeLat
        self.placeLong = placeLong
        self.placeName = placeName
        self.city = city
        self.postalCode = postalCode
        self.country = country
    }
    
    
}

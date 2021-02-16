//
//  Property.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import Foundation
import CoreLocation

public class Property: Decodable {
    
    let id : String
    let bedrooms : Int
    let name : String
    let latitude : Double
    let longitude : Double
    
    init(id: String, bedrooms: Int, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.bedrooms = bedrooms
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bedrooms
        case name
        case latitude
        case longitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}

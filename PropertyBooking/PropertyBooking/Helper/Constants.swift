//
//  Constants.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import Foundation

class Constants {
    
    static let apiBaseUrl = "https://s3-eu-west-1.amazonaws.com/product.versioning.com/"
    //private let apiVersion = ""
    
    static let latitude = 59.329440
    static let longitude = 18.069124
}

enum SuffixURL: String {
    case apartmentsList = "apartments"
}

enum Format: String {
    case json = "json"
}

enum ResponseError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
}

struct Location {
    let latitude : Double
    let longitude : Double
}

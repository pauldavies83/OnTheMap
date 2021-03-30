//
//  Location.swift
//  OnTheMap
//
//  Created by Paul Davies on 29/03/2021.
//

import UIKit

struct StudentInformationResponse: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
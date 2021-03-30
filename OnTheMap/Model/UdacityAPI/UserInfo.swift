//
//  UserInfp.swift
//  OnTheMap
//
//  Created by Paul Davies on 30/03/2021.
//

import Foundation

struct UserInfo: Codable, FirstFiveSecure {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}

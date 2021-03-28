//
//  CreateSessionRequest.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import Foundation

struct CreateSessionRequest: Codable {
    
    let udacity: Credentials
    
    struct Credentials: Codable {
        let username: String
        let password: String
    }
    
    static func build(username: String, password: String) -> CreateSessionRequest {
        return CreateSessionRequest(udacity: Credentials(username: username, password: password))
    }
}

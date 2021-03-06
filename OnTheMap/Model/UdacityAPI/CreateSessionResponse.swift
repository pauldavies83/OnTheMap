//
//  CreateSessionResponse.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import Foundation

struct CreateSessionResponse: Codable, FirstFiveSecure {
    let account: Account
    let session: Session
    
    struct Account: Codable {
        let registered: Bool
        let key: String
    }
    
    struct Session: Codable {
        let id: String
        let expiration: String
    }
}

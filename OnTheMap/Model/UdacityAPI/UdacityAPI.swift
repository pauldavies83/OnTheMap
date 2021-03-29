//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import Foundation

class UdacityAPI {
    
    struct Auth {
        static var userId = ""
        static var sessionId = ""
    }
    
    enum UdacityAPIError: Error {
        case Forbidden, BadResponse, Other(Error?)
        
        public var description: String {
            switch self {
                case .Forbidden: return "Incorrect username or password"
                case .BadResponse: return "A bad response was returned from the server"
                case .Other(let originalError): return originalError?.localizedDescription ?? "Another error occurred"
            }
        }
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case locations
        
        var stringValue: String {
            switch self {
                case .session: return Endpoints.base + "/session"
                case .locations: return Endpoints.base + "/StudentLocation?limit=100"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, UdacityAPIError?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                 if httpResponse.statusCode == 403 {
                    DispatchQueue.main.async {
                        completion(nil, UdacityAPIError.Forbidden)
                    }
                    return
                 }
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, UdacityAPIError.Other(error))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data.dropFirst(5))
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, UdacityAPIError.BadResponse)
                }
            }
        }
        task.resume()
    }
    
    class func createSession(username: String, password: String, completion: @escaping ((Bool, UdacityAPIError?) -> Void)) {
        let body = CreateSessionRequest.build(username: username, password: password)
        taskForPOSTRequest(url: Endpoints.session.url, responseType: CreateSessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.userId = response.account.key
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping ((Bool, UdacityAPIError?) -> Void)) {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, UdacityAPIError.BadResponse)
                }
            } else {
                Auth.sessionId = ""
                Auth.userId = ""
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        }
        task.resume()
    }
    
    class func getLocations(completion: @escaping ([Location], UdacityAPIError?) -> Void) {
        taskForGETRequest(url: Endpoints.locations.url, response: LocationsResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], UdacityAPIError.Other(error))
            }
        }
    }
}

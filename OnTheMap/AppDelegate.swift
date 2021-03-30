//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import UIKit

protocol StudentInformationDataSource {
    var studentInformation: [StudentInformation] { get }
    
    func refreshData(completion: @escaping (Error?) -> Void)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, StudentInformationDataSource {
    
    var studentInformation: [StudentInformation] = []
    
    func refreshData(completion: @escaping (Error?) -> Void) {
        UdacityAPI.getStudentLocations { (locations, error) in
            if error == nil {
                self.studentInformation = locations
            }
            completion(error)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


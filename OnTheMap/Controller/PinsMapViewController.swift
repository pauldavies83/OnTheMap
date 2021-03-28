//
//  PinsMapViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import UIKit

class PinsMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityAPI.logout { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "Logout Failed", message: error?.description, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.show(alertVC, sender: nil)
            }
        }
    }

}

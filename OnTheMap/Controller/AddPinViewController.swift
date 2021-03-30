//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 30/03/2021.
//

import UIKit

class AddPinViewController: UIViewController {

    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationButton.layer.cornerRadius = 5

        configureUI(isLoading: false)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        configureUI(isLoading: true)
        // look up geoLocation
        performSegue(withIdentifier: "verifyLocation", sender: sender)
        configureUI(isLoading: false)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureUI(isLoading: Bool) {
        locationText.isEnabled = !isLoading
        linkText.isEnabled = !isLoading
        findLocationButton.isEnabled = !isLoading
        activityIndicator.isHidden = !isLoading
        if (isLoading) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

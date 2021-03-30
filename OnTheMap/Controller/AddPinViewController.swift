//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 30/03/2021.
//

import UIKit
import MapKit

class AddPinViewController: UIViewController {

    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findLocationButton.layer.cornerRadius = 5

        configureUI(isLoading: false)
    }
    
    fileprivate func showVerifyLocation(location: CLLocation, description: String?) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyLocationViewController") as! VerifyLocationViewController
        vc.location = location
        vc.locationText = description ?? locationText.text
        vc.linkText = linkText.text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        if linkText.text == nil || linkText.text?.count == 0 {
            presentErrorAlert(title: "Link was empty", message: "Please enter a value for link")
            return
        }
        
        if let addressString = locationText.text {
            configureUI(isLoading: true)

            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
                self.configureUI(isLoading: false)
                if error != nil {
                    self.presentErrorAlert(title: "Location lookup failed", message: error?.localizedDescription)
                    return
                }
                if let location = placemarks?.first?.location {
                    self.showVerifyLocation(location: location, description: placemarks!.first!.name)
                }
            }
        } else {
            return
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func presentErrorAlert(title: String, message: String?) {
        let alertVC = UIAlertController(title: title, message: message?.description ?? "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: true, completion: nil)
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

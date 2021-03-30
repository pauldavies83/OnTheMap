//
//  PinsViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 30/03/2021.
//

import UIKit

class PinsViewController: UIViewController {

    let locationsDataSource =  (UIApplication.shared.delegate as! LocationDataSource)
    var locations: [Location] {
        return locationsDataSource.locations
    }
    
    let uiBusy = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var refreshButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        uiBusy.hidesWhenStopped = true
        uiBusy.isUserInteractionEnabled = false

        self.navigationItem.title = "On The Map"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(self.logout))
        refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(self.refresh))

        configureUI(isLoading: false)
    }
    
    @objc func logout(_ sender: Any) {
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
    
    @objc func refresh() {
        let uiBusy = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        uiBusy.isUserInteractionEnabled = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)

        locationsDataSource.refreshLocations { (error) in
            uiBusy.stopAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(self.refresh))
        }
    }

    func configureUI(isLoading: Bool) {
        if isLoading {
            uiBusy.startAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        } else {
            uiBusy.stopAnimating()
            self.navigationItem.rightBarButtonItem = refreshButton
        }
    }

}

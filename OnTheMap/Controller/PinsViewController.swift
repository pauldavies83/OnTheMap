//
//  PinsViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 30/03/2021.
//

import UIKit

class PinsViewController: UIViewController {

    let locationsDataSource =  (UIApplication.shared.delegate as! StudentInformationDataSource)
    var locations: [StudentInformation] {
        return locationsDataSource.studentInformation
    }
    
    var refreshDataCompleted: (() -> Void)? = nil
    
    let uiBusy = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var busyButton: UIBarButtonItem?
    var refreshButton: UIBarButtonItem?
    var addButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        uiBusy.hidesWhenStopped = true
        uiBusy.isUserInteractionEnabled = false

        self.navigationItem.title = "On The Map"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(self.logout))
        
        busyButton = UIBarButtonItem(customView: uiBusy)
        refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(self.refresh))
        addButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(self.addPin))

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
        configureUI(isLoading: true)

        locationsDataSource.refreshData { (error) in
            self.configureUI(isLoading: false)
            self.refreshDataCompleted?()
        }
    }
    
    @objc func addPin() {
        let next = self.storyboard?.instantiateViewController(identifier: "AddPinNavigationController") as! UINavigationController
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }

    func configureUI(isLoading: Bool) {
        self.navigationItem.rightBarButtonItems = []
        if isLoading {
            uiBusy.startAnimating()
            self.navigationItem.rightBarButtonItems = [addButton!, busyButton!]
        } else {
            uiBusy.stopAnimating()
            self.navigationItem.rightBarButtonItems = [addButton!, refreshButton!]
        }
    }

}

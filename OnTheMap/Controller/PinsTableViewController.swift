//
//  PinsTableViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import UIKit

class PinsTableViewController: UITableViewController {
    
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
        
        refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(self.refresh))
        
        configureUI(isLoading: false)
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
    
    func configureUI(isLoading: Bool) {
        if isLoading {
            uiBusy.startAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        } else {
            uiBusy.stopAnimating()
            self.navigationItem.rightBarButtonItem = refreshButton
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = "\(locations[indexPath.row].firstName) \(locations[indexPath.row].lastName)"
        cell.detailTextLabel?.text = locations[indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlToOpen = URL(string: locations[indexPath.row].mediaURL)
        if urlToOpen != nil {
            UIApplication.shared.open(urlToOpen!, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
}

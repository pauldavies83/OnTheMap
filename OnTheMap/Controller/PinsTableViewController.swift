//
//  PinsTableViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import UIKit

class PinsTableViewController: PinsViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        cell.textLabel?.text = "\(locations[indexPath.row].firstName) \(locations[indexPath.row].lastName)"
        cell.detailTextLabel?.text = locations[indexPath.row].mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlToOpen = URL(string: locations[indexPath.row].mediaURL)
        if urlToOpen != nil {
            UIApplication.shared.open(urlToOpen!, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
}

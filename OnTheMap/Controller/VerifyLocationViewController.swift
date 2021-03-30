//
//  VerifyLocationViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 30/03/2021.
//

import UIKit

class VerifyLocationViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButton.layer.cornerRadius = 5
    }
    
    @IBAction func finish(_ sender: Any) {
        // post to API
        dismiss(animated: true, completion: nil)
    }
}

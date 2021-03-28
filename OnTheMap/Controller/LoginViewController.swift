//
//  ViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    let signupUrl = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
    }

    @IBAction func loginButton(_ sender: Any) {
        let alertVC = UIAlertController(title: "Login Failed", message: "message", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    @IBAction func signupButton(_ sender: Any) {
        UIApplication.shared.open(signupUrl, options: [:], completionHandler: nil)
    }
}


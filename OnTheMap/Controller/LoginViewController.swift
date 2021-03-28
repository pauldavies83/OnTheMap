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
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        
        configureUI(isLoading: false)
    }

    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            configureUI(isLoading: true)
            UdacityAPI.createSession(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                self.configureUI(isLoading: false)
                if success {
                    let next = self.storyboard?.instantiateViewController(identifier: "PinsTabBarController") as! UITabBarController
                    next.modalPresentationStyle = .fullScreen
                    self.present(next, animated: true, completion: nil)
                } else {
                    let alertVC = UIAlertController(title: "Login Failed", message: error?.description, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.show(alertVC, sender: nil)
                }
            }
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        UIApplication.shared.open(signupUrl, options: [:], completionHandler: nil)
    }
    
    
    func configureUI(isLoading: Bool) {
        activityView.isHidden = !isLoading
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
        loginButton.isEnabled = !isLoading
    }
}


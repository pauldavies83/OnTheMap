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
                if success {
                    StudentInformationDataSource.sharedInstance.refreshData { (error) in
                        self.configureUI(isLoading: false)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.presentPinsTabBarController()
                    }
                } else {
                    self.configureUI(isLoading: false)
                    self.presentErrorAlert(title: "Login Failed", message: error?.description)
                }
            }
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        UIApplication.shared.open(signupUrl, options: [:], completionHandler: nil)
    }
    
    fileprivate func presentPinsTabBarController() {
        let next = self.storyboard?.instantiateViewController(identifier: "PinsTabBarController") as! UITabBarController
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }

    
    func configureUI(isLoading: Bool) {
        activityView.isHidden = !isLoading
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
        loginButton.isEnabled = !isLoading
        
        if (isLoading) {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
    }
}

extension UIViewController {
    func presentErrorAlert(title: String, message: String?) {
        let alertVC = UIAlertController(title: title, message: message?.description ?? "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: false, completion: nil)
    }
}

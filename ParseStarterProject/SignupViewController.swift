//
//  SignupViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Guilherme Henrique Crozariol on 2017-01-09.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCompareTextField: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        
        let user = PFUser()
        
        startLoadingAnimation()
        
        user.username = usernameTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            self.stopLoadingAnimation()
            self.createAlert(title: "Woops!", message: "The username field is empty.")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            self.stopLoadingAnimation()
            self.createAlert(title: "Woops!", message: "The email field is empty.")
            return
        }
        
        guard let password = passwordTextField.text, let passwordCompare = passwordCompareTextField.text, password == passwordCompare else {
            self.stopLoadingAnimation()
            self.createAlert(title: "Woops!", message: "Passwords don't match.")
            return
        }
        
        user.signUpInBackground(block: { (success, error) in
            
        self.stopLoadingAnimation()
            
        if error != nil {
                
            var displayErrorMessage = "Please, try again later."
                
            if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                    
                displayErrorMessage = errorMessage
                    
            }
                
            self.createAlert(title: "Woops!", message: displayErrorMessage)
                
            } else {
                
                self.createAlert(title: "Yay!", message: "You have signed up successfully! You can now log into your account.")
                self.performSegue(withIdentifier: "logInSegue", sender: self)
                
            }
            
        })
        
    }
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "backToMainSegue", sender: self)
    }
    
    func startLoadingAnimation() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

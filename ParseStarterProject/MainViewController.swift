//
//  MainViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Guilherme Henrique Crozariol on 2017-01-09.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController {

    @IBAction func logIn(_ sender: Any) {
        performSegue(withIdentifier: "logInSegue", sender: self)
    }
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

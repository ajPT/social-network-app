//
//  SignUpVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 02/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: - IBActions
    
    //MARK: Create Account
    @IBAction func onSignUpBtnPressed(sender: UIButton) {
        //FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
        // ...
        //}
    }

    //MARK: Cancel
    @IBAction func onCancelBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

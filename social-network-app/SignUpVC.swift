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
        
        if let email = emailField.text where email != "", let password = passwordField.text where password != "" {
            
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                if error != nil {
                    if error?.code == STATUS_ERROR_EMAIL_ALREADY_IN_USE {
                        UtilAlerts().showAlert(self, title: "Email already exists", msg: "The email address is already in use by another account.")
                    } else if error?.code == STATUS_ERROR_WEAK_PASSWORD {
                        self.passwordField.text = ""
                        UtilAlerts().showAlert(self, title: "Weak Password", msg: "The password must be 6 characters long or more.")
                    } else {
                        print(error)
                        UtilAlerts().showAlert(self, title: "Unknown Reason", msg: "The account cannot be created.")
                    }
                } else {
                    //Account created
                    print(user)
                    NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                    FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (_: FIRUser?, err: NSError?) in
                        if err != nil {
                            print(err)
                            UtilAlerts().showAlert(self, title: "Unknown Reason", msg: "The account was created but the login failed.")
                        } else {
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                    })
                }
            }
            
        } else {
            UtilAlerts().showAlert(self, title: "Email and Password Required", msg: "You must enter an email and a password")
        }
       
    }

    //MARK: Cancel
    @IBAction func onCancelBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

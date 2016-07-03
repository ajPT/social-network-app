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
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_EMAIL_ALREADY_IN_USE, msg: UtilAlerts.LoginMessages.ERROR_EMAIL_ALREADY_IN_USE)
                    } else if error?.code == STATUS_ERROR_WEAK_PASSWORD {
                        self.passwordField.text = ""
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_WEAK_PASSWORD, msg: UtilAlerts.LoginMessages.ERROR_WEAK_PASSWORD)
                    } else {
                        print(error)
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.LoginMessages.UNKNOWN_ERROR_CREATE)
                    }
                } else {
                    //Account created
                    print(user)
                    NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                    FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (_: FIRUser?, err: NSError?) in
                        if err != nil {
                            print(err)
                            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.LoginMessages.UNKNOWN_ERROR_CREATE_LOGIN)
                        } else {
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                    })
                }
            }
            
        } else {
            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.MISSING_EMAIL_PASSWORD, msg: UtilAlerts.LoginMessages.MISSING_EMAIL_PASSWORD)
        }
       
    }

    //MARK: Cancel
    @IBAction func onCancelBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

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
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_EMAIL_ALREADY_IN_USE, msg: UtilAlerts.GeneralMessages.ERROR_EMAIL_ALREADY_IN_USE)
                    } else if error?.code == STATUS_ERROR_WEAK_PASSWORD {
                        self.passwordField.text = ""
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_WEAK_PASSWORD, msg: UtilAlerts.GeneralMessages.ERROR_WEAK_PASSWORD)
                    } else if error?.code == STATUS_ERROR_NETWORK_REQUEST_FAILED {
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_NETWORK_REQUEST_FAILED, msg: UtilAlerts.NetworkMessages.ERROR_NETWORK_REQUEST_FAILED)
                    } else {
                        print(error)
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.CreateAccountMessages.UNKNOWN_ERROR_CREATE)
                    }
                } else {
                    if let userr = user {
                        let provider = userr.providerID
                        let uid = userr.uid
                        if provider != "" && uid != "" {
                            DataService.ds.createFirebaseUser(uid, userInfo: ["provider":provider])
                            NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
                            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (_: FIRUser?, err: NSError?) in
                                if err != nil {
                                    print(err)
                                    UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.CreateAccountMessages.UNKNOWN_ERROR_CREATE_LOGIN)
                                } else {
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                }
                            })
                        }
                    } else {
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
                    }
                }
            }
            
        } else {
            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.MISSING_EMAIL_PASSWORD, msg: UtilAlerts.GeneralMessages.MISSING_EMAIL_PASSWORD)
        }
       
    }

    //MARK: Cancel
    @IBAction func onCancelBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

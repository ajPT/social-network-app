//
//  ViewController.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 26/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class InitialVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    //MARK: - IBOutlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: user)
            }
        }
//        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
//            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
//        }
    }
    
    
    //MARK: - IBActions
    
    //MARK: Facebook Login
    @IBAction func onFacebookBtnPressed(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            if error != nil {
                UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)

                self.authenticateWithFirebaseCredential(credential: credential)
                
            }
        }
    }
    
    //MARK: Google Login
    @IBAction func onGoogleBtnPressed(sender: UIButton) {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            let idToken = user.authentication.idToken
            let accessToken = user.authentication.accessToken
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(idToken, accessToken: accessToken)
            
            authenticateWithFirebaseCredential(credential: credential)
            
        } else {
            print("\(error)")
            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
        }
    }
    
//    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
//                withError error: NSError!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }
    
    //MARK: Email/Password Login
    @IBAction func onLoginBtnPressed(sender: UIButton) {
    
        if let email = emailField.text where email != "", let password = passwordField.text where password != "" {
            
            authenticateWithFirebaseEmailPassword(email: email, password: password)
            
        } else {
            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.MISSING_EMAIL_PASSWORD, msg: UtilAlerts.LoginMessages.MISSING_EMAIL_PASSWORD)
        }
        
    }

    //MARK: Create new account
    @IBAction func onSignUpBtnPressed(sender: UIButton) {
        performSegueWithIdentifier(SEGUE_CREATE_ACCOUNT, sender: nil)
    }
    
    
    //MARK: - Firebase auth
    
    //MARK: Facebook/Google
    func authenticateWithFirebaseCredential(credential credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if error != nil {
                UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
            } else if let appUser = user {
        
                let uid = appUser.uid

                var userInformation = [String: AnyObject]()
                
                if let email = appUser.email {
                    userInformation["email"] = email
                }
                if let photoUrl = appUser.photoURL {
                    let urlStr = String(photoUrl)
                    userInformation["photo"] = urlStr
                }
                if let username = appUser.displayName {
                    //let name = username.stringByReplacingOccurrencesOfString(" ", withString: "")
                    //userInformation["username"] = name
                    userInformation["username"] = username
                }
                
                DataService.ds.createFirebaseUser(uid, userInfo: userInformation)
                //NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
                
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: appUser)
                
            } else {
                UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
            }
        }

    }
    
    //MARK: Email/Password
    func authenticateWithFirebaseEmailPassword(email email: String, password: String) {
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            if let err = error {
                
                if err.code == STATUS_ERROR_NETWORK_REQUEST_FAILED {
                    UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_NETWORK_REQUEST_FAILED, msg: UtilAlerts.NetworkMessages.ERROR_NETWORK_REQUEST_FAILED)
                } else if err.code == STATUS_ERROR_INTERNAL_ERROR {
                    UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_INTERNAL_ERROR, msg: UtilAlerts.LoginMessages.ERROR_INTERNAL_ERROR)
                } else if err.code == STATUS_ERROR_USER_NOT_FOUND {
                    UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_USER_NOT_FOUND, msg: UtilAlerts.LoginMessages.ERROR_USER_NOT_FOUND)
                } else if err.code == STATUS_ERROR_WRONG_PASSWORD {
                    UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_WRONG_PASSWORD, msg: UtilAlerts.LoginMessages.ERROR_WRONG_PASSWORD)
                } else {
                    UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.LoginMessages.UNKNOWN_ERROR_LOGIN)
                }
                
            } else if let appUser = user {
                
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: appUser)
                
            } else {
                
                UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
                
            }
        })
    }
    
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_LOGGED_IN {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let feedVC = nav.viewControllers[0] as? FeedVC {
                    if let user = sender as? FIRUser {
                        feedVC.currentUser = user
                    }
                }
            }
        }
    }
    
    
}


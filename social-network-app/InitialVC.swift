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
//        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
//            self.performSegueWithIdentifier(LOGGED_IN, sender: nil)
//        }
    }
    
    
    //MARK: - IBActions
    
    //MARK: Facebook Login
    @IBAction func onFacebookBtnPressed(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            if error != nil {
                print("Facebook login failed!")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                print("Login successful.")
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    if error != nil {
                        print("Login failed. \(error.debugDescription)")
                    } else {
                        print("userID: \(user?.uid)")
                        NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(LOGGED_IN, sender: nil)
                    }
                }
                
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
            //let userId = user.userID
            //let email = user.profile.email
            let idToken = user.authentication.idToken
            let accessToken = user.authentication.accessToken
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(idToken, accessToken: accessToken)

            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                print("UserID: \(user?.uid)")
                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                self.performSegueWithIdentifier(LOGGED_IN, sender: nil)
            }

        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    //MARK: Email/Password Login
    @IBAction func onLoginBtnPressed(sender: UIButton) {
    
        if let email = emailField.text where email != "", let password = passwordField.text where password != "" {
        
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                // ...
                print("USER: \(user)")
                print("ERROR: \(error)")
            }
            
        } else {
            UtilAlerts().showAlert(self, title: "Email and Password Required", msg: "You must enter an email and a password")
        }
        
    }

    //MARK: Create new account
    @IBAction func onSignUpBtnPressed(sender: UIButton) {
        performSegueWithIdentifier("createAccountScreen", sender: nil)
    }


}


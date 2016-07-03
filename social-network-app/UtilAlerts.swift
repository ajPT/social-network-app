//
//  UtilAlerts.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 02/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation
import UIKit

class UtilAlerts {
    
    //TODO: - Move alert messages to here
    
    
    //MARK: - Alerts messages
    
    //MARK: Titles
    struct Titles {
        static let ERROR_EMAIL_ALREADY_IN_USE = "Email already exists"
        static let ERROR_WEAK_PASSWORD = "Weak password"
        static let MISSING_EMAIL_PASSWORD = "Email and password required"
        static let ERROR_NETWORK_REQUEST_FAILED = "No network connection"
        static let UNKNOWN = "Unknown reason"
    }
    
    //MARK: Login
    struct LoginMessages {
        static let ERROR_EMAIL_ALREADY_IN_USE = "The email address is already in use by another account."
        static let ERROR_WEAK_PASSWORD = "The password must be 6 characters long or more."
        static let UNKNOWN_ERROR_CREATE = "The account cannot be created."
        static let UNKNOWN_ERROR_CREATE_LOGIN = "The account was created but the login failed."
        static let MISSING_EMAIL_PASSWORD = "You must enter an email and a password"
        static let ERROR_NETWORK_REQUEST_FAILED = "Please check your network connection."
        static let UNKNOWN_ERROR_LOGIN = "Login failed."
    }
    
    
    
    //MARK: - Show Alert
    func showAlert(vc: UIViewController, title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        vc.presentViewController(alert, animated: true, completion: nil)
    }

}
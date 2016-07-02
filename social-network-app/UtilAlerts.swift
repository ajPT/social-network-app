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
        //...
    }
    
    //MARK: Login
    struct LoginMessages {
        //...
    }
    
    
    //MARK: - Show Alert
    func showAlert(vc: UIViewController, title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        vc.presentViewController(alert, animated: true, completion: nil)
    }

}
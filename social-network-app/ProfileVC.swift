//
//  ProfileVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 12/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var userImg: RoundedImage!
    @IBOutlet weak var usernameField: RoundedBorderedTextField!
    @IBOutlet weak var emailField: RoundedBorderedTextField!
    @IBOutlet weak var oldPassField: RoundedBorderedTextField!
    @IBOutlet weak var newPassField: RoundedBorderedTextField!
    
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func onChangePicPressed(sender: UIButton) {
    }
    
    @IBAction func onSaveBtnPressed(sender: UIButton) {
    }


}

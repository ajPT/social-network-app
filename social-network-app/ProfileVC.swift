//
//  ProfileVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 12/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Properties
    
    var imagePicker: UIImagePickerController!
    var currentUser: FIRUser!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var userImg: RoundedImage!
    @IBOutlet weak var usernameField: RoundedBorderedTextField!
    @IBOutlet weak var emailField: RoundedBorderedTextField!
    @IBOutlet weak var oldPassField: RoundedBorderedTextField!
    @IBOutlet weak var newPassField: RoundedBorderedTextField!
    
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        updateInitialContent()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func onChangePicPressed(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.allowsEditing = false
            if let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary) {
                imagePicker.mediaTypes = availableMediaTypes
            }
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onSaveBtnPressed(sender: UIButton) {
        
    }

    
    //MARK: - Aux
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            userImg.image = img
        }
    }
    
    func updateInitialContent() {
    
    }


}

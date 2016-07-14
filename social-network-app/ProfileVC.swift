//
//  ProfileVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 12/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - Properties
    
    var imagePicker: UIImagePickerController!
    var currentUser: FIRUser!
    var request: Request?
    
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
        let userID = currentUser.uid
        DataService.ds.REF_USERS.child(userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let userInfo = snapshot.value as? [String: AnyObject] {
                if let username = userInfo["username"] as? String {
                    self.usernameField.placeholder = username
                }
                if let email = userInfo["email"] as? String {
                    self.emailField.placeholder = email
                }
                if let photo = userInfo["photo"] as? String {
                    let url = NSURL(string: photo)!
                    self.request = Alamofire.request(.GET, url).response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) in
                        if error == nil {
                            if let imgData = data {
                                let image = UIImage(data: imgData)
                                self.userImg.image = image
                            }
                        }
                    })
                }
            }
        })
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            request?.cancel()
        }
    }


}

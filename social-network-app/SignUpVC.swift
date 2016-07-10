//
//  SignUpVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 02/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    var imagePicker: UIImagePickerController!
    var userImage: UIImage?

    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userPic: UIButton!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }

    
    //MARK: - IBActions
    
    //MARK: Create Account
    @IBAction func onSignUpBtnPressed(sender: UIButton) {
        
        if let username = usernameField.text where username != "", let email = emailField.text where email != "", let password = passwordField.text where password != "" {
            
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                if let err = error {
                    if err.code == STATUS_ERROR_EMAIL_ALREADY_IN_USE {
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_EMAIL_ALREADY_IN_USE, msg: UtilAlerts.GeneralMessages.ERROR_EMAIL_ALREADY_IN_USE)
                    } else if err.code == STATUS_ERROR_WEAK_PASSWORD {
                        self.passwordField.text = ""
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_WEAK_PASSWORD, msg: UtilAlerts.GeneralMessages.ERROR_WEAK_PASSWORD)
                    } else if err.code == STATUS_ERROR_NETWORK_REQUEST_FAILED {
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.ERROR_NETWORK_REQUEST_FAILED, msg: UtilAlerts.NetworkMessages.ERROR_NETWORK_REQUEST_FAILED)
                    } else {
                        print(err)
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.CreateAccountMessages.UNKNOWN_ERROR_CREATE)
                    }
                } else if let firebaseUser = user {
                    if firebaseUser.uid != "" {
                        
                        var userInformation: [String: AnyObject] = [
                            "username": username,
                            "email": email
                        ]
                        
                        if self.userImage != nil {
                            let img = UIImageJPEGRepresentation(self.userImage!, 0.2)!
                            let imgPath = "\(NSDate.timeIntervalSinceReferenceDate())"
                            let metadataInfo = FIRStorageMetadata()
                            metadataInfo.contentType = "image/jpeg"
                            DataService.ds.REF_STORAGE.child(imgPath).putData(img, metadata: metadataInfo, completion: { (metadata: FIRStorageMetadata?, error: NSError?) in
                                if error != nil {
                                    print(error)
                                } else if let downloadedData = metadata {
                                    if let downloadedURL = downloadedData.downloadURL() {
                                        let url = downloadedURL.absoluteString
                                            print(url)
                                        userInformation["photo"] = url
                                        DataService.ds.createFirebaseUser(firebaseUser.uid, userInfo: userInformation)
                                        NSUserDefaults.standardUserDefaults().setValue(firebaseUser.uid, forKey: KEY_UID)
                                    }
                                }
                            })
                            
// ---------------
// IMAGESHACK
// ---------------
//                            let img = UIImageJPEGRepresentation(self.userImage!, 0.2)
//                            let url = NSURL(string: URL_UPLOAD)
//                            let imageShackKey = KEY_IMAGESHACK.dataUsingEncoding(NSUTF8StringEncoding)
//                            let format = "json".dataUsingEncoding(NSUTF8StringEncoding)
//
//                            if let uploadUrl = url, let imgData = img, let keyData = imageShackKey, let formatData = format {
//                                Alamofire.upload(.POST, uploadUrl, multipartFormData: { multipartFormData in
//                                    multipartFormData.appendBodyPart(data: keyData, name: "key")
//                                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
//                                    multipartFormData.appendBodyPart(data: formatData, name: "format")
//                                    },
//                                    encodingCompletion: { encodingResult in
//                                        switch encodingResult {
//                                        case .Success(let upload, _, _):
//                                            upload.responseJSON { response in
//                                                if let resultJSON = response.result.value as? [String:AnyObject] {
//                                                    if let linksDict = resultJSON["links"] as? [String:AnyObject] {
//                                                        if let link = linksDict["image_link"] as? String {
//                                                            userInformation["photo"] = link
//                                                            DataService.ds.createFirebaseUser(firebaseUser.uid, userInfo: userInformation)
//                                                            NSUserDefaults.standardUserDefaults().setValue(firebaseUser.uid, forKey: KEY_UID)
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        case .Failure(let encodingError):
//                                            print(encodingError)
//                                        }
//                                    }
//                                )
//                                
//                            }
                        } else {
                            DataService.ds.createFirebaseUser(firebaseUser.uid, userInfo: userInformation)
                            NSUserDefaults.standardUserDefaults().setValue(firebaseUser.uid, forKey: KEY_UID)
                        }
                        
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    } else {
                        UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
                    }
                } else {
                    UtilAlerts().showAlert(self, title: UtilAlerts.Titles.UNKNOWN, msg: UtilAlerts.GeneralMessages.UNKNOWN)
                }
            }
        } else {
            UtilAlerts().showAlert(self, title: UtilAlerts.Titles.MISSING_FIELDS, msg: UtilAlerts.GeneralMessages.MISSING_FIELDS)
        }
       
    }

    
    //MARK: Cancel
    @IBAction func onCancelBtnPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Image Picker
    @IBAction func onAddPicBtnPressed(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.allowsEditing = false
            if let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary) {
                imagePicker.mediaTypes = availableMediaTypes
            }
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    //MARK - Aux
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            userPic.setImage(img, forState: .Normal)
            userImage = img
        }
        
        
    }
    
    

}

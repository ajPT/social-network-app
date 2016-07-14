//
//  FeedVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 03/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    static var cache = NSCache()
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var currentUser: FIRUser!
    var spin: SpinIndicator!
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraImg: UIImageView!
    @IBOutlet weak var descriptionField: RoundedBorderedTextField!

    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont(name: "NotoSans-Bold", size: 15.0)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        tableView.estimatedRowHeight = 365
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        spin = SpinIndicator()
        spin.startSpinning(self.view)
        
        DataService.ds.REF_POSTS.queryOrderedByChild("timestamp").observeEventType(.Value, withBlock: { (snapshot) in
            
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let postDic = snap.value as? [String: AnyObject] {
                        let post = Post(key: snap.key, postInfo: postDic)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
            self.spin.stopSpinning()
        })
    }

    //MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            let post = posts[indexPath.row]
            cell.request?.cancel()
            cell.requestPhoto?.cancel()
            var img: UIImage?
            if let imgUrl = post.postImageUrl {
                img = FeedVC.cache.objectForKey(imgUrl) as? UIImage
            }
            cell.configureCell(post, img: img)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.postImageUrl == nil {
            return 170
        }
        return tableView.estimatedRowHeight
    }
    
    
    //MARK: - IBActions
    
    @IBAction func onCameraPressed(sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.allowsEditing = false
            if let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary) {
                    imagePicker.mediaTypes = availableMediaTypes
                }
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onPostBtnPressed(sender: RoundedShadowedBtn) {
        if let desc = descriptionField.text where desc != "" {
            if let selectedImg = cameraImg.image where imageSelected == true {
                let imgData = UIImageJPEGRepresentation(selectedImg, 0.2)!
                let metadataInfo = FIRStorageMetadata()
                metadataInfo.contentType = "image/jpeg"
                let imgPath = "\(NSDate.timeIntervalSinceReferenceDate())"
                DataService.ds.REF_STORAGE.child(imgPath).putData(imgData, metadata: metadataInfo) { metadata, error in
                    if (error != nil) {
                        print(error)
                    } else if let downloadedData = metadata {
                        if let downloadURL = downloadedData.downloadURL() {
                            let url = downloadURL.absoluteString
                            self.postToFirebase(url)
                        }
                    } else {
                        self.postToFirebase(nil)
                    }
                }
            } else {
                postToFirebase(nil)
            }
        
        } else {
            //TODO: Add Alert "You must insert a description..."
        }
        
// ---------------
// IMAGESHACK
// ---------------
//        if let desc = descriptionField.text where desc != "" {
//            if let img = cameraImg.image where imageSelected == true {
//                let url = NSURL(string: URL_UPLOAD)
//                let imageShackKey = KEY_IMAGESHACK.dataUsingEncoding(NSUTF8StringEncoding)
//                let jpegImg = UIImageJPEGRepresentation(img, 0.2)
//                let format = "json".dataUsingEncoding(NSUTF8StringEncoding)
//                
//                if let myUrl = url {
//
//                    Alamofire.upload(.POST, myUrl, multipartFormData: { multipartFormData in
//                        if let keyData = imageShackKey, let imgData = jpegImg, let formatData = format {
//                            multipartFormData.appendBodyPart(data: keyData, name: "key")
//                            multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpeg")
//                            multipartFormData.appendBodyPart(data: formatData, name: "format")
//                        }
//                        },
//                        encodingCompletion: { encodingResult in
//                            switch encodingResult {
//                            case .Success(let upload, _, _):
//                                upload.responseJSON { response in
//                                    if let resultJSON = response.result.value as? [String:AnyObject] {
//                                        if let linksDict = resultJSON["links"] as? [String:AnyObject] {
//                                            if let link = linksDict["image_link"] as? String {
//                                                self.postToFirebase(link)
//                                            }
//                                        }
//                                    }
//                                }
//                            case .Failure(let encodingError):
//                                print(encodingError)
//                            }
//                        }
//                    )
//                    
//                }
//            } else {
//                self.postToFirebase(nil)
//            }
//        } else {
//            //Add Alert "You must insert ..."
//        }
    }
    
    @IBAction func onProfileBtnPressed(sender: UIButton) {
        performSegueWithIdentifier("showProfileVC", sender: currentUser)
    }
    
    @IBAction func onLogoutBtnPressed(sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let err as NSError {
            print(err)
        }
        FeedVC.cache.removeAllObjects()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Aux
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            cameraImg.image = img
            imageSelected = true
        }
    }
    
    func postToFirebase(imgUrl: String?) {
        var postDict: [String:AnyObject] = [
            "description" : descriptionField.text!,
            "likes" : 0,
            "username" : currentUser.uid,
            "timestamp" : -1 * NSDate.timeIntervalSinceReferenceDate()
        ]
        if let imageURL = imgUrl {
            postDict["image"] = imageURL
        }
        
        DataService.ds.createFirebasePostWithAutoID(currentUser.uid, postInfo: postDict)
        
        resetPostFields()
        tableView.reloadData()
    }
    
    func resetPostFields() {
        descriptionField.text = ""
        cameraImg.image = UIImage(named: "camera")
        imageSelected = false
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_USER_PROFILE {
            if let profileVC = segue.destinationViewController as? ProfileVC {
                if let user = sender as? FIRUser {
                    profileVC.currentUser = user
                }
            }
        }
    }


}

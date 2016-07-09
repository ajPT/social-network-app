//
//  PostCell.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 03/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    //MARK: - Properties
    var request: Request?
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    
    //MARK: - Cell Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        postImage.clipsToBounds = true
    }
    
    
    //MARK: - Cell Configuration

    func configureCell (post: Post, img: UIImage?) {
        //userImage.image =
        //userName.text =
        numberOfLikes.text = "\(post.likes)"
        postDescription.text = post.postDescription
        
        if img != nil {
            postImage.image = img
        } else if let imgUrl = post.postImageUrl {
            request = Alamofire.request(.GET, imgUrl).validate(contentType: ["image/*"]).response(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) in
                
                if error == nil {
                    if let imgData = data {
                        let img = UIImage(data: imgData)
                        FeedVC.cache.setObject(img!, forKey: imgUrl)
                        self.postImage.image = img
                    }
                }
            })
        } else {
            postImage.hidden = true
        }
        
        //like button
        let likeRef = DataService.ds.REF_CURRENT_USER_LIKES.child(post.postKey)
        
        likeRef.observeSingleEventOfType(.Value, andPreviousSiblingKeyWithBlock: { (snapshot: FIRDataSnapshot, _) in
            
            if let _ = snapshot.value as? NSNull {
                let emptyHeartImg = UIImage(named: "heart-empty")!
                self.likeBtn.setImage(emptyHeartImg, forState: .Normal)
            } else {
                let fullHeartImg = UIImage(named: "heart-full")!
                self.likeBtn.setImage(fullHeartImg, forState: .Normal)
            }
        }) { (error: NSError) in
            print(error)
        }
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func onLikeBtnPressed(sender: UIButton) {
    
    }
    
}

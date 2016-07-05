//
//  PostCell.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 03/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {

    //MARK: - Properties
    var request: Request?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    
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
        
    }
    
}

//
//  PostCell.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 03/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    //MARK: IBOutlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    
    //MARK: Cell Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        postImage.clipsToBounds = true
    }
    
    
    //MARK: Cell Configuration

    func configureCell (post: Post) {
        //userImage.image =
        //userName: UILabel!
        numberOfLikes.text = String(post.likes)
        postDescription.text = post.postDescription
        //postImage =

    }
    
}

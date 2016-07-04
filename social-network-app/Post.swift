//
//  Post.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 04/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation

class Post {

    //MARK: - Properties
    
    private var _postDescription: String!
    private var _postImageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String?

    
    //MARK: - Getters/Setters

    var postDescription: String {
        return _postDescription
    }
    
    var postImageUrl: String? {
        return _postImageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String? {
        return _postKey
    }
    
    
    //MARK: - Initializers
    
    init(desc: String, imageUrl: String?, username: String) {
        _postDescription = desc
        _postImageUrl = imageUrl
        _username = username
        _likes = 0
    }
    
    init(key: String, postInfo: [String : AnyObject]) {
        _postKey = key
        
        if let desc = postInfo["description"] as? String {
            _postDescription = desc
        }
        
        if let imageUrl = postInfo["image"] as? String {
            _postImageUrl = imageUrl
        }
        
        if let likes = postInfo["likes"] as? Int {
            _likes = likes
        }
    }
    
    
}
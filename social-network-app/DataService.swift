//
//  DataService.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 29/06/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()

    //MARK: - Properties

    private var _REF_BASE = FIRDatabase.database().reference()
    private var _REF_STORAGE = FIRStorage.storage().referenceForURL("gs://social-network-c3fed.appspot.com")

    
    //MARK: - Computed Properties
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_STORAGE: FIRStorageReference {
        return _REF_STORAGE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_BASE.child("users")
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_BASE.child("posts")
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = _REF_BASE.child("users/\(uid)")
        return user
    }
    
    var REF_CURRENT_USER_LIKES: FIRDatabaseReference {
        let user = REF_CURRENT_USER
        let userLikes = user.child("likes")
        return userLikes
    }
    
    var REF_CURRENT_USER_POSTS: FIRDatabaseReference {
        let user = REF_CURRENT_USER
        let userPosts = user.child("posts")
        return userPosts
    }
    
    
    //MARK: - Functions
    
    func createFirebaseUser(uid: String, userInfo: [String: AnyObject]) {
        REF_USERS.child(uid).setValue(userInfo)
    }

    func createFirebasePostWithAutoID(postInfo: [String: AnyObject]) {
        //create post
        let autoIDPost = REF_POSTS.childByAutoId()
        autoIDPost.setValue(postInfo)
        //save to current user
        let postKey = autoIDPost.key
        REF_CURRENT_USER.child("posts").updateChildValues([postKey: true])
    }
    
}
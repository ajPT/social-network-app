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
    
    
    //MARK: - Computed Properties
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
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
    
    
    //MARK: - Functions
    
    func createFirebaseUser(uid: String, userInfo: [String: String]) {
        REF_USERS.child(uid).setValue(userInfo)
    }

    func createFirebasePostWithAutoID(postInfo: [String: AnyObject]) {
        let autoIDPost = REF_POSTS.childByAutoId()
        autoIDPost.setValue(postInfo)
    }
    
}
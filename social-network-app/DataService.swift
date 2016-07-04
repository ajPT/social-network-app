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
    
    private var _REF_BASE = FIRDatabase.database().reference()
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_BASE.child("users")
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_BASE.child("posts")
    }
    
    func createFirebaseUser(uid: String, userInfo: [String: String]) {
        REF_USERS.child(uid).setValue(userInfo)
    }
    
}
//
//  FeedVC.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 03/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    var posts = [Post]()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { (snapshot) in
            
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
            print(post.postDescription)
            return cell
        } else {
            return PostCell()
        }
        
    }
    

}

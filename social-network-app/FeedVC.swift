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
    static var cache = NSCache()
    var posts = [Post]()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 365
        
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
            cell.request?.cancel()
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
    

}

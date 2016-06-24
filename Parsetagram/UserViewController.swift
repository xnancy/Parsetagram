//
//  UserViewController.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/23/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import Parse

class UserViewController: HomeViewController {
    
    /* ----------- HELPER FUNCTIONS ----------- */
    override func loadData() {
        let query = PFQuery(className: "Post")
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        query.limit = 20
        if allPosts == nil {
            allPosts = []
        } else {
            query.skip = (allPosts?.count)!
        }
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let post = Post.init(post: object)
                        self.allPosts?.append(post)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.imageTable.reloadData()
        }
    }
}

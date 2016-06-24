//
//  PostClass.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/21/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import Foundation
import Parse

class Post: NSObject {
    
    /* ----------- VARIABLES ----------- */
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    var image: UIImage?
    var comments: [Comment]?
    var parseID: String?
    var timeStamp: String?
    var username: String?
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    /* ----------- INITIALIZERS ----------- */
    init(image: UIImage?, caption: String?) {
        self.image = image
        self.caption = caption
        self.commentsCount = 0
        self.likesCount = 0
        self.comments = []
        self.parseID = ""
        self.username = PFUser.currentUser()?.username
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        self.timeStamp = dateFormatter.stringFromDate(NSDate())
    }
    
    init(post: PFObject?) {
        super.init()
        
        self.caption = post!["caption"] as? String
        self.likesCount = post!["likesCount"] as? Int
        

        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            do {
                let photoTemp = post!["media"] as! PFFile
                let middleTemp = try photoTemp.getData()
                let imageTemp = try UIImage(data: middleTemp)
                self.image = imageTemp
            } catch {
                print("Something went wrong!")
            }
        }
        
        self.commentsCount = post!["commentsCount"] as? Int
        self.comments = []
        if post!["comments"] != nil {
            for commentDict in post!["comments"] as! NSArray {
                let temp = commentDict as! NSDictionary
                let comment = Comment.init(text: temp["text"] as! String, author: temp["author"] as! String)
                comments?.append(comment)
            }
        }
        self.parseID = post!["parseID"] as? String
        self.timeStamp = post!["date"] as? String
        self.username = post!["username"] as? String
    }
    
    /* ----------- FUNCTIONS ----------- */
    func addComment(text: String, author: String) {
        let newComment = Comment.init(text: text, author: author)
        print("Initiated comment with text \(newComment.text)")
        comments?.append(newComment)
        updateServer()
    }
    
    func postToServer() {
        print("CALLED")
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        addElementsToPost(post)
        // Save object (following function will save the object in Parse asynchronously)
        print("POSTING")
        post.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
                print("POSTED")
                self.parseID = post.objectId
                self.updateServer()
            } else {
                // There was a problem, check error.description
            }
        }
    }

    func updateServer() {
        var query = PFQuery(className:"Post")
        print("current parse id: \(parseID)")
        query.getObjectInBackgroundWithId(parseID!) {
            (post: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let post = post {
                self.addElementsToPost(post)
                // Save object (following function will save the object in Parse asynchronously)
                post.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
                    if (success) {
                        self.parseID = post.objectId
                    } else {
                        // There was a problem, check error.description
                    }
                }
            }
        }
    }
    
    func addElementsToPost(post: PFObject) {
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = likesCount
        post["commentsCount"] = commentsCount
        var commentsArray:[NSDictionary] = []
        for comment in comments! {
            print("Comment posted")
            let commentsDict: NSDictionary = [:]
            commentsDict.setValue(comment.text, forKey: "text")
            commentsDict.setValue(comment.author, forKey: "author")
            commentsArray.append(commentsDict)
        }
        post["comments"] = commentsArray
        post["parseID"] = parseID
        post["date"] = timeStamp
        post["username"] = username
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
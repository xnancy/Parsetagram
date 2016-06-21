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
    var caption: String?
    var likesCount: Int?
    var commentsCount: Int?
    var image: UIImage?
    
    // initialize post with values
    init(image: UIImage?, caption: String?) {
        self.image = image
        self.caption = caption
        self.commentsCount = 0
        self.likesCount = 0
    }
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    func postToServer() {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }

    /**
     Method to convert UIImage to PFFile
 
     - parameter image: Image that the user wants to upload to parse
 
     - returns: PFFile for the the data in the image
     */
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
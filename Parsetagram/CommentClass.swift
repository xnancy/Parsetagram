//
//  CommentClass.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/22/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import Foundation
import Parse
import EBPhotoPages

/*
 The EBPhotoCommentProtocol should be implemented by an object
 that owns comment information about a photo.
 */

class Comment: NSObject, EBPhotoCommentProtocol {
    var text: String?
    var author: String?
    
    init(text: String?, author: String?) {
        super.init()
        
        self.text = text
        self.author = author
    }
    
    func commentText() -> String! {
        return text
    }
    
    func authorName() -> String! {
        return author
    }
}


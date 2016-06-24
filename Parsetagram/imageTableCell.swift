//
//  imageTableCell.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/22/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import Foundation
import UIKit
import EBPhotoPages

class imageTableCell: UITableViewCell {
    
    /* ----- VARIABLES ----- */
    var delegate: TableCellDelegate?
    var postToShowIndex: Int?

    /* ----- OUTLETS ----- */
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionText: UILabel!
    @IBOutlet weak var photoView2: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    /* ----- ACTIONS ----- */
    @IBAction func onImageButton(sender: AnyObject) {
        
        delegate?.presentPhotoViewController(postToShowIndex!)
    }
}

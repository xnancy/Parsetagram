//
//  CaptionPageViewController.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/21/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class CaptionPageViewController: UIViewController, UITextViewDelegate {

    /* ----- VARIABLES ----- */
    var rawUIImage: UIImage?
    
    /* ----- OUTLETS ----- */
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load raw UIImage to view 
        pictureImageView.image = rawUIImage
        captionTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ---------- TEXT VIEW DELEGATE ---------- */
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Share a moment ... " {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Share a moment ... "
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    /* ---------- BUTTONS ---------- */
    
    @IBAction func onShare(sender: AnyObject) {
        // Create post
        let newPost = Post.init(image: rawUIImage, caption: captionTextView.text)
        newPost.postToServer()
       
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

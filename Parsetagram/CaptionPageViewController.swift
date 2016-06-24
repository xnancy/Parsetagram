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
    
    @IBOutlet weak var popUpView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "banner4"), forBarMetrics: .Default)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(hue: 0.6167, saturation: 1, brightness: 1, alpha: 1.0) /* #004cff */
]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.tabBarController!.tabBar.backgroundImage = UIImage(named: "banner4rotate")
        
        popUpView.hidden = true
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
        
        // Show confirmation 
        popUpView.hidden = false
        popUpView.alpha = 1.0
        pictureImageView.alpha = 0
        captionTextView.alpha = 0
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CaptionPageViewController.update), userInfo: nil, repeats: false)
    }
    
    func update() {
        popUpView.hidden = true
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.popUpView.alpha = 0.0
            }, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
}

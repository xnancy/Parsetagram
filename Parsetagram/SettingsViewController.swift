//
//  SettingsViewController.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/24/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBAction func onLogout(sender: AnyObject) {
        performSegueWithIdentifier("logout", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            usernameField.text = PFUser.currentUser()?.username
        passwordField.text = PFUser.currentUser()?.password
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.blackColor().CGColor
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "banner4")?.alpha(0.8), forBarMetrics: .Default)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(hue: 0.6167, saturation: 1, brightness: 1, alpha: 1.0) /* #004cff */
        ]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.tabBarController!.tabBar.backgroundImage = UIImage(named: "banner4rotate")?.alpha(0.8)
        self.tabBarController!.tabBar.autoresizesSubviews = true
        self.tabBarController!.tabBar.clipsToBounds = true

    }
}

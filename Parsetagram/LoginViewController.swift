//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/20/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    /* ----------- OUTLETS ----------- */
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    /* ----------- VIEW CONTROLLER ----------- */
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.textColor =  UIColor(hue: 0.6167, saturation: 1, brightness: 1, alpha: 1.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ----------- ACTIONS ----------- */
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            // Check if sign in was successful
            if user != nil {
                print("You're logged in!")
                // Login user
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }
    @IBAction func onSignUp(sender: AnyObject) {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            // Check if sign up was successful
            if let error = error {
                print(error.localizedDescription)
                if error.code == 202 {
                    print("Username is taken")
                }
            } else {
                print("User Registered successfully")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }
}

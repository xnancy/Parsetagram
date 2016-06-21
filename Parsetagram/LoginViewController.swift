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
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

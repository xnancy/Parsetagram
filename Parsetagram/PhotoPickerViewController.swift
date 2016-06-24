//
//  PhotoPickerViewController.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/20/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit

class PhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var settingsButton: UIImageView!
    @IBOutlet weak var cameraButton: UIImageView!
    /* ----------- VARIABLES ----------- */
    var imageToPost: UIImage?
    
    /* ----------- VIEW CONTROLLER ----------- */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        settingsButton.image = settingsButton.image?.maskWithColor(UIColor(hue: 0.6167, saturation: 1, brightness: 1, alpha: 1.0) /* #004cff */
)
        cameraButton.image = cameraButton.image?.maskWithColor(UIColor(hue: 0.6167, saturation: 1, brightness: 1, alpha: 1.0) /* #004cff */
)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "banner4"), forBarMetrics: .Default)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(hue: 0.6167, saturation: 1, brightness: 1, alpha: 1.0) /* #004cff */
]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ----------- ACTIONS ----------- */
    @IBAction func onCameraOptions(sender: AnyObject) {
        // Pick from Camera
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func onLibraryOption(sender: AnyObject) {
        // Pick from Photo Library
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    /* ----------- UIIMAGEPICKERCONTROLLER DELEGATE FUNCTIONS ----------- */
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        imageToPost = editedImage
        self.performSegueWithIdentifier("toCaptionPage", sender: self)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* ----------- SEGUES ----------- */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toCaptionPage") {
            let vc = segue.destinationViewController as! CaptionPageViewController
            vc.rawUIImage = imageToPost
        }
    }
}

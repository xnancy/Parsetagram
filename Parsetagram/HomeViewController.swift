//
//  HomeViewController.swift
//  Parsetagram
//
//  Created by Nancy Xu on 6/21/16.
//  Copyright © 2016 Nancy Xu. All rights reserved.
//

import UIKit
import Parse
import QuartzCore
import CoreGraphics
import AVFoundation
import EBPhotoPages

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TableCellDelegate, EBPhotoPagesDataSource, EBPhotoPagesDelegate {

    /* ----- OUTLETS ----- */
    @IBOutlet weak var imageTable: UITableView!
    
    /* ----- VARIABLES ----- */
    var allPosts: [Post]?
    var postToShowIndex: Int?
    let CellIdentifier = "TableViewCell", HeaderViewIdentifier = "TableViewHeaderView"
    
    /* ----------- VIEW CONTROLLER ---------- */
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        imageTable.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "banner4")?.alpha(0.8), forBarMetrics: .Default)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(hue: 0.6167, saturation: 1, brightness: 1, alpha: 1.0) /* #004cff */
]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.tabBarController!.tabBar.backgroundImage = UIImage(named: "banner4rotate")?.alpha(0.8)
        self.tabBarController!.tabBar.autoresizesSubviews = true
        self.tabBarController!.tabBar.clipsToBounds = true
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        imageTable.insertSubview(refreshControl, atIndex: 0)
    
        imageTable.delegate = self
        imageTable.dataSource = self
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ---------- SCROLL VIEW DELEGATE ---------- */
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = imageTable.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - imageTable.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && imageTable.dragging) {
                isMoreDataLoading = true
                
                loadData()
            }
        }
    }
    
    /* ---------- REFRESH CONTROL ---------- */
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
        imageTable.reloadData()
    }
    
    /* ---------- TABLE VIEW DATA SOURCE ---------- */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! imageTableCell
        print("size in cell: \(allPosts?.count)")
        cell.photoView.image = allPosts![indexPath.section].image
        cell.photoView2.image = allPosts![indexPath.section].image
        cell.captionText.text = allPosts![indexPath.section].caption
        cell.delegate = self
        cell.postToShowIndex = indexPath.section
        cell.dateLabel.text = allPosts![indexPath.section].timeStamp
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        print("size in header: \(allPosts?.count)")
        print("section is \(section)")
        //TODO HERE
        if allPosts!.count > section {
            header.textLabel!.text = allPosts![section].username
        }
        return header
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allPosts!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /* ----------- HELPER FUNCTIONS ----------- */
    func loadData() {
        let query = PFQuery(className: "Post")
        query.limit = 20
        if allPosts == nil {
            allPosts = []
        } else {
            query.skip = (allPosts?.count)!
        }
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let post = Post.init(post: object)
                        self.allPosts?.append(post)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.imageTable.reloadData()
        }
    }
 
    /* ---------- TABLE CELL DELEGATE ---------- */
    func presentPhotoViewController(postToShowIndex: Int) {
        self.postToShowIndex = postToShowIndex
        let photoPagesController = EBPhotoPagesController.init(dataSource: self, delegate: self, photoAtIndex: postToShowIndex)
        self.presentViewController(photoPagesController, animated: true) {() -> Void in }
    }
    
    /* ---------- PHOTO PAGES DATA SOURCE ---------- */
    // SINGLE IMAGE MODEL FOR IMAGETOSHOW
    func photoPagesController(photoPagesController: EBPhotoPagesController!, shouldExpectPhotoAtIndex index: Int) -> Bool {
        if 0 <= index && index < allPosts?.count {
            return true
        } else {
            return false
        }
    }
    
    /* ---------- PHOTO PAGES DATA SOURCE ---------- */
    /* IMAGES */
    func photoPagesController(controller: EBPhotoPagesController!, imageAtIndex index: Int) -> UIImage! {
        return allPosts?[index].image
    }
    
    func photoPagesController(controller: EBPhotoPagesController!, captionForPhotoAtIndex index: Int) -> String! {
        return allPosts?[index].caption
    }
    
    /* ----------- COMMENTS ---------- */
    func photoPagesController(controller: EBPhotoPagesController!, commentsForPhotoAtIndex index: Int) -> [AnyObject]! {
        return allPosts![index].comments
    }
    
    func photoPagesController(photoPagesController: EBPhotoPagesController!, shouldAllowCommentingForPhotoAtIndex index: Int) -> Bool {
        return true
    }
    
    func photoPagesController(photoPagesController: EBPhotoPagesController!, shouldShowCommentsForPhotoAtIndex index: Int) -> Bool {
        return true
    }
    
    func photoPagesController(controller: EBPhotoPagesController!, didPostComment commentText: String!, forPhotoAtIndex index: Int) {
        allPosts![index].addComment(commentText, author: (PFUser.currentUser()?.username)!)
    }
}

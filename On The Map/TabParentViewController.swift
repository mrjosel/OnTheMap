//
//  TabParentViewController.swift
//  On The Map
//
//  Created by Brian Josel on 7/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class TabParentViewController: UIViewController {
    //generic Parent VC for Tab and List VC since many functions are shared

    //rightBarButtonItems
    var refreshButton: UIBarButtonItem?
    var infoPostButton: UIBarButtonItem?
    
    //dummy refresh string used in refresh method (overridden by sub classes)
    var messageText: String { return "This is the Super Class messageText"}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set Title
        self.navigationItem.title = "On The Map"
        
        //Set Logout, postLocation, and refresh buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        infoPostButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "postLocation")
        self.navigationItem.rightBarButtonItems = [refreshButton!, infoPostButton!]
    }
    
    func postLocation() {
        let infoPostVC = self.storyboard?.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        self.presentViewController(infoPostVC, animated: true, completion: nil)
    }
    
    func refresh() -> Void {
        //refresh studentLocations

        //disable buttons while refreshing
        self.enableNavButtons(false)

        //get latest Student Locations
        ParseClient.sharedInstance().getStudentLocations() { success, error in
            if let error = error {
                //alert user
                self.makeAlert(self, title: "Refresh Failed", error: error)
            } else {
                //alert user
                self.handler()
                self.makeAlert(self, title: self.messageText, error: nil)
            }
            //enable buttons when finished
            self.enableNavButtons(true)
        }
    }

    func handler() {
        //dummy handler function
        println("This is the Super Class Handler")
    }
    
    func logout() -> Void {
        //Logout of Udacity Client
        //disable Logout button while logging out
        self.enableNavButtons(false)
        
        //if facebook token exists, logout of facebook
        if let token = FacebookClient.sharedInstance().token {
            FacebookClient.sharedInstance().manager.logOut()
        }
        
        UdacityClient.sharedInstance().udacityLogout() { success, error in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    //Clear student locations array and sessionID/userID
                    ParseClient.sharedInstance().studentLocations = []
                    UdacityClient.sharedInstance().sessionID = nil
                    UdacityClient.sharedInstance().userID = nil
                    //dismissVC
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                //alert user of failure
                self.makeAlert(self, title: "Logout Failed", error: error!)
                self.enableNavButtons(true)
            }
        }
    }
    
    func enableNavButtons(enable: Bool) {
        //enable/disable navbuttons and tabBar
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationItem.leftBarButtonItem!.enabled = enable
            self.refreshButton?.enabled = enable
            self.infoPostButton?.enabled = enable
            self.tabBarController?.tabBar.userInteractionEnabled = enable
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//
//  ListViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/27/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userTableView: UITableView!
    
    //rightBarButtonItems
    var refreshButton: UIBarButtonItem?
    var infoPostButton: UIBarButtonItem?
    
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
    
    func refresh() -> Void {
        ParseClient.sharedInstance().getStudentLocations() { success, error in
            if let error = error {
                self.makeAlert(self, title: "Refresh Failed", error: error)
            } else {
                //reload data
                self.userTableView.reloadData()
                //create UIAlertVC
                self.makeAlert(self, title: "List Refreshed", error: nil)
            }
        }
    }
    
    func postLocation() {
        let infoPostVC = self.storyboard?.instantiateViewControllerWithIdentifier("InformationPostingViewController") as! InformationPostingViewController
        self.presentViewController(infoPostVC, animated: true, completion: nil)
    }
    
    //Logout of App
    func logout() -> Void {
        
        //disable Logout button while logging out
        self.enableNavButtons(false)
        
        //execute logout method
        UdacityClient.sharedInstance().udacityLogout() { success, error in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    //Clear student locations array and sessionID/userID
                    ParseClient.sharedInstance().studentLocations = []
                    UdacityClient.sharedInstance().clearIDs()
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
    
    //launch website of studentLocation mediaURL
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        var urlString = ParseClient.sharedInstance().studentLocations[indexPath.row].mediaURL!
        
        //fix url if no http:// exists
        if urlString.lowercaseString.rangeOfString("http") == nil {
            urlString = "http://" + urlString
        }
        //create URL and launch
        let url = NSURL(string: urlString)
        app.openURL(url!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableCell") as! UITableViewCell
        cell.textLabel?.text = "\(ParseClient.sharedInstance().studentLocations[indexPath.row].lastName!), \(ParseClient.sharedInstance().studentLocations[indexPath.row].firstName!)"
        cell.imageView?.image = UIImage(named: "Pin")
        return cell
    }
    

}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set Login Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
    }
    
    func refresh() -> Void {
        ParseClient.sharedInstance().getStudentLocations() { success, result, error in
            if let error = error {
                //create UIAlertVC
                var alertVC = UIAlertController(title: "Refresh Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                
                //create actions, OK dismisses alert
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertVC.addAction(ok)
                
                //display alert
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alertVC, animated: true, completion: nil)
                })
            } else {
                self.userTableView.reloadData()
                //create UIAlertVC
                var alertVC = UIAlertController(title: "Refreshed", message: "User Data Refreshed", preferredStyle: UIAlertControllerStyle.Alert)
                
                //create actions, OK dismisses alert
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertVC.addAction(ok)
                
                //display alert
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alertVC, animated: true, completion: nil)
                })

            }
        }
    }
    
    func logout() -> Void {
        //Logout of Udacity Client
        UdacityClient.sharedInstance().udacityLogout() { success, error in
            if (success != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    //Clear student locations array
                    ParseClient.sharedInstance().studentLocations = []
                    //dismissVC
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                //create UIAlertVC
                var alertVC = UIAlertController(title: "Login Failed", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                
                //create actions, OK dismisses alert
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertVC.addAction(ok)
                
                //display alert
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alertVC, animated: true, completion: nil)
                })
            }
        }
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

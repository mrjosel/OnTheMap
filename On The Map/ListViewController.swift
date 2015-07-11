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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableCell") as! UITableViewCell
        cell.textLabel?.text = "\(ParseClient.sharedInstance().studentLocations[indexPath.row].lastName!), \(ParseClient.sharedInstance().studentLocations[indexPath.row].firstName!)"
        return cell
    }
    

}

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
    
    //Array of studentLocation objects
    var studentLocations: [ParseStudentLocation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set Login Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        println(self.studentLocations?.count)
//        //Get student locations
//        ParseClient.sharedInstance().getStudentLocations() {sucess, result, error in
//            if !sucess {
//                println(error)
//            } else {
//                if let result = result as? [String: AnyObject] {
//                    var studentLocationsDict = result[ParseClient.ParameterKeys.RESULTS] as! [[String: AnyObject]]
//                    for studentLocation in studentLocationsDict {
//                        self.studentLocations.append(ParseStudentLocation(parsedJSONdata: studentLocation))
//                        self.studentLocations.sort({ $0.lastName < $1.lastName })
//                    }
//                    println(self.studentLocations[17].lastName)
//                }
//            }
//        }
    }
    
    func logout() -> Void {
        //Logout of Udacity Client
        UdacityClient.sharedInstance().udacityLogout() { success, error in
            if (success != nil) {
                dispatch_async(dispatch_get_main_queue(), {
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
        return studentLocations!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableCell") as! UITableViewCell
        cell.textLabel?.text = "\(self.studentLocations![indexPath.row].lastName!), \(self.studentLocations![indexPath.row].firstName!)"
        return cell
    }
    

}

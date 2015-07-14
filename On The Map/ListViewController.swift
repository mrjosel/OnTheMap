//
//  ListViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/27/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class ListViewController: TabParentViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }
    
//    func refresh() -> Void {
//        //refresh studentLocations
//        
//        //disable buttons while refreshing
//        self.enableNavButtons(false)
//        
//        //get latest Student Locations
//        ParseClient.sharedInstance().getStudentLocations() { success, error in
//            if let error = error {
//                //alert user
//                self.makeAlert(self, title: "Refresh Failed", error: error)
//            } else {
//                //alert user
//                self.makeAlert(self, title: "Table Refreshed", error: nil)
//            }
//            //enable buttons when finished
//            self.enableNavButtons(true)
//        }
//    }


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

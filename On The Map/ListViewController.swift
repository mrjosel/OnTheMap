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
    
    //overriding messageText for refresh method in super class
    override var messageText: String { return "Table Refreshed"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(animated: Bool) {
        println("ListVC appear")
    }
    
    //launch website of studentLocation mediaURL
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        println(ParseClient.sharedInstance().studentLocations[indexPath.row].mediaURL)
        let urlString = ParseClient.sharedInstance().studentLocations[indexPath.row].mediaURL
            println("urlString")
            //create URL and launch
        if let url = NSURL(string: urlString!) {
                app.openURL(url)
            } else {
                self.makeAlert(self, title: "No URL", error: nil)
            }
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
    
    override func handler() {
        //override function for super class refresh method
        println("list done did it")
        self.userTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

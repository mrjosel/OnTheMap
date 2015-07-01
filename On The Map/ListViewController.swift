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
    
//    required init(coder aDecoder: NSCoder) {
//        //initialize tabBarButton
//        super.init(coder: aDecoder)
//        dispatch_async(dispatch_get_main_queue(), {
//            self.tabBarItem.image = UIImage(named: "List")
//            self.tabBarItem.title = "List"
//            self.tabBarItem.tag = 1
//        })
//        
//    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        // Do any additional setup after loading the view.
////        if let sessionID = UdacityClient.sharedInstance().sessionID {
////            //do nothing
////        } else {
////            let loginVC: LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
////            self.navigationController?.presentViewController(loginVC, animated: false, completion: nil)
////        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

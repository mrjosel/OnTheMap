//
//  MapViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/27/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    required init(coder aDecoder: NSCoder) {
        //initialize tabBarButton
        super.init(coder: aDecoder)
        self.tabBarItem.image = UIImage(named: "Map")
        self.tabBarItem.title = "Map"
        self.tabBarItem.tag = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("mapViewVC")
        // Do any additional setup after loading the view.
        if let sessionID = UdacityClient.sharedInstance().sessionID {
            //do nothing
        } else {
            let loginVC: LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.presentViewController(loginVC, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

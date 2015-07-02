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
    
    @IBOutlet weak var mapView: MKMapView!
    
    required init(coder aDecoder: NSCoder) {
        //initialize tabBarButton
        super.init(coder: aDecoder)
        dispatch_async(dispatch_get_main_queue(), {
//            self.tabBarItem.image = UIImage(named: "Map")
//            self.tabBarItem.title = "Map"
//            self.tabBarItem.tag = 0
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        })
        
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        // Do any additional setup after loading the view.
//        if let sessionID = UdacityClient.sharedInstance().sessionID {
//            //do nothing
//        } else {
//            let loginVC: LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//            self.navigationController?.presentViewController(loginVC, animated: false, completion: nil)
//        }
//    }
    
    func logout() -> Void {
        //TODO - perform HTTP DELETE request
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set mapView delegate as self
        self.mapView.delegate = self

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
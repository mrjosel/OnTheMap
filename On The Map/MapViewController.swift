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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set mapView delegate as self
        self.mapView.delegate = self
        
        //Set Login Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")

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
                let ok = UIAlertAction(title: "Go Back", style: UIAlertActionStyle.Default, handler: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
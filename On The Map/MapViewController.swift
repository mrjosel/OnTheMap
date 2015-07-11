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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
    
        //empty array of MKPointAnnotations
        var annotations: [MKPointAnnotation] = []
        
        //create pin annotations for each studentLocation
        for studentLocation in ParseClient.sharedInstance().studentLocations {
            println(studentLocation)
            
            //optional names and url, if user has nil for a name, value is forced to ""
            var first: String?
            var last: String?
            var url: String?
            
            //set lat/lon values
            let lat = CLLocationDegrees(studentLocation.latitude!)
            let lon = CLLocationDegrees(studentLocation.longitude!)
            
            //make coordinate object
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            //get names and URL
            if let firstName = studentLocation.firstName {
                first = firstName
            } else {
                first = ""
            }
            
            if let lastName = studentLocation.lastName {
                last = lastName
            } else {
                last = ""
            }
            
            if let mediaURL = studentLocation.mediaUrl {
                url = mediaURL
            } else {
                url = ""
            }
            
            //create the annotation
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = url
            
            //add annotation to annotations array
            annotations.append(annotation)
        }
        
        //load completed annotations array to the map
        self.mapView.addAnnotations(annotations)

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
                println("refreshed")
                self.mapView.reloadInputViews()
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
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
            
            //set lat/lon values
            let lat = CLLocationDegrees(studentLocation.latitude!)
            let lon = CLLocationDegrees(studentLocation.longitude!)
            
            //make coordinate object
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            //get names and URL
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            //create the annotation
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            //add annotation to annotations array
            annotations.append(annotation)
        }
        
        //load completed annotations array to the map
        self.mapView.addAnnotations(annotations)

    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
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
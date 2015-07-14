//
//  MapViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/27/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: TabParentViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //empty array of MKPointAnnotations
    var annotations: [MKPointAnnotation] = []
    
    //overriding messageText for refresh method in super class
    override var messageText: String { return "Map Refreshed"}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set mapView delegate as self
        self.mapView.delegate = self
        self.mapView.zoomEnabled = true
        
        //create pin annotations for each studentLocation
        for studentLocation in ParseClient.sharedInstance().studentLocations {
            
            //set lat/lon values
            let lat = CLLocationDegrees(studentLocation.latitude!)
            let lon = CLLocationDegrees(studentLocation.longitude!)
            
            //make coordinate object
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            //get names and URL
            let first = studentLocation.firstName!
            let last = studentLocation.lastName!
            let mediaURL = studentLocation.mediaURL!
            
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
    
    //create view for annotation
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        //reuse ID and pinView
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
        //fix url if no http:// exists
        var urlString = annotationView.annotation.subtitle!
        
        if urlString.lowercaseString.rangeOfString("http") == nil {
            urlString = "http://" + urlString
        }
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: urlString)!)
        }
    }
    
    override func handler() {
        //override function for super class refresh method
        self.mapView.reloadInputViews()
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
//                self.makeAlert(self, title: "Map Refreshed", error: nil)
//            }
//            //enable buttons when finished
//            self.enableNavButtons(true)
//        }
//    }

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
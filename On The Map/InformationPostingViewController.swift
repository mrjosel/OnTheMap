//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Brian Josel on 7/11/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class InformationPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var findLocationButton: BorderedButton!
    @IBOutlet weak var submitButton: BorderedButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //for keyboard adjustments
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    //coordinates and annotation for location search
    var coords: CLLocationCoordinate2D?
    var annotations: [MKPointAnnotation] = []
    
    //default string for searchField
    let defaultString = "Enter Location Here"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // get keybard notifications
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove keyboard notifications
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //configure UI
        self.configureUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findOnTheMap(sender: BorderedButton) {
        //geocode search string
        if self.searchField.text != self.defaultString { //else, do nothing
            
            //Create geocoder, start search
            let geoCoder = CLGeocoder()
            let searchString = self.searchField.text
            geoCoder.geocodeAddressString(searchString, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) in
                    
                    if let error = error {
                        //create alert
                        var alertVC = UIAlertController(title: "Search Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        //create okAction, add to alertVC
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { handler in
                            self.searchField.text = self.defaultString
                        }
                        alertVC.addAction(okAction)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            //display alert
                            self.presentViewController(alertVC, animated: true, completion: nil)
                        })
                    } else {
                        //get location from placemarks
                        let placemark = placemarks[0] as! CLPlacemark
                        let location = placemark.location
                        
                        //create the annotation
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = location.coordinate
                        
                        //add annotation to annotations array and load array to the map
                        self.annotations.append(annotation)
                        self.mapView.addAnnotations(self.annotations)
                        
                        //set zoom window
                        let mapWindow = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                        
                        //display map, make all UI changes
                        dispatch_async(dispatch_get_main_queue(), {
                            self.resignFirstResponder()
                            self.mapView.hidden = false
                            self.mapView.setRegion(mapWindow, animated: true)
                            self.topView.backgroundColor = self.makeColor(65, gVal: 117, bVal: 164)
                            self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                            self.bottomView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
                            self.findLocationButton.hidden = true
                            self.submitButton.hidden = false
                            self.urlField.hidden = false
                        })
                }
            })
        }
    }
    
    @IBAction func submitLocation(sender: BorderedButton) {
        //TODO - implement
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

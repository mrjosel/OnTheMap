//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Brian Josel on 7/11/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import MapKit
//import AddressBook

class InformationPostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var searchField: StoredPlaceholderTextField!
    @IBOutlet weak var urlField: StoredPlaceholderTextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var findLocationButton: InfoPostBorderedButton!
    @IBOutlet weak var submitButton: InfoPostBorderedButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //for keyboard adjustments
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    //coordinates, locationString,  and annotation for location search
    var coords: CLLocationCoordinate2D?
    var annotations: [MKPointAnnotation] = []
    var locationString: String?
    
    //default string for searchField
    let defaultSearchString = "Enter City Here"
    let defaultURLString = "Enter URL Here"
    
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
        if self.searchField.text != self.defaultSearchString { //else, do nothing
            
            //Create geocoder, start search
            let geoCoder = CLGeocoder()
            let searchString = self.searchField.text
            geoCoder.geocodeAddressString(searchString, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) in
                    
                    if let error = error {
                        //create alert
                        println("error in geocoding")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.makeAlert(self, title: "Can't Find Location", error: error)
                        })
                    } else {
                        println("successful geocoding")
                        //get address and coordinate from placemarks
                        let placemark = placemarks[0] as! CLPlacemark
                        self.coords = placemark.location.coordinate
                        let addressDict = placemark.addressDictionary
                        self.locationString = (placemark.addressDictionary["FormattedAddressLines"]![0]! as! String)
                        
                        //create the annotation
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = self.coords!
                        
                        //add annotation to annotations array and load array to the map
                        self.annotations.append(annotation)
                        self.mapView.addAnnotations(self.annotations)
                        
                        //set zoom window
                        let mapWindow = MKCoordinateRegionMakeWithDistance(self.coords!, 500, 500)
                        
                        //display map, make all UI changes
                        self.locationFoundMode(mapWindow)
                }
            })
        }
    }
    
    func locationFoundMode(window: MKCoordinateRegion) {
        //UI behavior once location is found
        dispatch_async(dispatch_get_main_queue(), {
            self.resignFirstResponder()
            self.mapView.hidden = false
            self.mapView.setRegion(window, animated: true)
            self.topView.backgroundColor = self.makeColor(65, gVal: 117, bVal: 164)
            self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.bottomView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            self.findLocationButton.hidden = true
            self.submitButton.hidden = false
            self.urlField.hidden = false
        })
    }
    
    //post new student location
    @IBAction func submitLocation(sender: BorderedButton) {

        //get lat and lon
        let lat = coords!.latitude as Double
        let lon = coords!.longitude as Double
        
        ParseClient.sharedInstance().postStudentLocation(self.locationString!, latitude: lat, longitude: lon, userURLstring: self.urlField.text) { success, error in
            if success {
                println("successful post")
                dispatch_async(dispatch_get_main_queue(), {
                    self.makeAlert(self, title: "Location Posted", error: nil)
                })
            } else {
                println("failed to post")
                dispatch_async(dispatch_get_main_queue(), {
                    self.makeAlert(self, title: "Update Failed", error: error)
                })
            }
        }
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
    
    //Cancel Posting Location
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

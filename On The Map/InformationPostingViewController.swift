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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var findLocationButton: BorderedButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //for keyboard adjustments
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    //coordinates and annotation for location search
    var coords: CLLocationCoordinate2D?
    var annotations: [MKPointAnnotation] = []
    
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
        if self.searchField.text != InfoPostVCConstants.defaultString {
            
            let geoCoder = CLGeocoder()
            let searchString = self.searchField.text
            
            geoCoder.geocodeAddressString(searchString, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) in
                    
                    if error != nil {
                        //TODO - Make Alert
                        println("Geocode failed with error: \(error.localizedDescription)")
                    } else {
                        let placemark = placemarks[0] as! CLPlacemark
                        let location = placemark.location
                        
                        //create the annotation
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = location.coordinate
//                        annotation.title = "\(first) \(last)"
//                        annotation.subtitle = mediaURL
                        
                        //add annotation to annotations array and load array to the map
                        self.annotations.append(annotation)
                        self.mapView.addAnnotations(self.annotations)
                        
                        //code for zooming in to pin
                        var zoomRect = MKMapRectNull;
                        let x = location.coordinate.latitude
                        let y = location.coordinate.longitude
                        let width = Double(self.mapView.frame.width)
                        let height = Double(self.mapView.frame.height)
                        let mapWindow = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
                        
//                        zoomRect = myLocationPointRect;
//                        zoomRect = MKMapRectUnion(zoomRect, currentDestinationPointRect);
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.mapView.hidden = false
                            self.mapView.setRegion(mapWindow, animated: true)
                        })
                        
                        
                        
//                        self.showMap()
                }
            })
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
    
    
    
//    func showMap() {
//        
//        let addressDict = [
//            kABPersonAddressCityKey as NSString: "guys",
//            kABPersonAddressStateKey: "lol",
//            kABPersonAddressZIPKey: "wut"
//        ]
//        
//        let place = MKPlacemark(coordinate: coords!, addressDictionary: addressDict)
//        let mapItem = MKMapItem(placemark: place)
//        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        
//        self.mapView.hidden = false
//    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

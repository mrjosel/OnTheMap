//
//  InfoPostVCExtensions.swift
//  On The Map
//
//  Created by Brian Josel on 7/11/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension InformationPostingViewController {
    
    struct InfoPostVCConstants {
        static let defaultString = "Enter Location Here"
    }
    
    func configureUI() {
        /* Configure tap recognizer */
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.tapRecognizer?.numberOfTapsRequired = 1
        
        //make blue color for use at various points
        let blue = makeColor(65, gVal: 117, bVal: 164)
        
        //search button
        self.findLocationButton.themeBorderedButton("search")
        
        //submit button
        self.submitButton.themeBorderedButton("submit")
        self.submitButton.hidden = true
        
        //hide urlField initially
        self.urlField.hidden = true
        
        //hide mapView initially
        self.mapView.hidden = true
        
        //enable zoom, set self as delegate
        self.mapView.zoomEnabled = true
        self.mapView.delegate = self

        
        //textLabels
        self.topLabel.textColor = blue
        self.topLabel.font = UIFont(name: "Roboto-Thin", size: 25.0)
        self.midLabel.textColor = blue
        self.midLabel.font = UIFont(name: "Roboto-Medium", size: 25.0)
        self.bottomLabel.textColor = blue
        self.bottomLabel.font = UIFont(name: "Roboto-Thin", size: 25.0)
        
        //view colors
        let grey = makeColor(225, gVal: 225, bVal: 225)
        self.topView.backgroundColor = grey
        self.bottomView.backgroundColor = grey
        self.view.bringSubviewToFront(self.bottomView)
        self.view.backgroundColor = blue
        
        //searchField configurations
        self.searchField.delegate = self
        self.searchField.text = InfoPostVCConstants.defaultString
        self.searchField.textColor = UIColor.whiteColor()
        self.searchField.font = UIFont(name: "Roboto-Medium", size: 17.0)
    }
    
    //textField delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == InfoPostVCConstants.defaultString {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = InfoPostVCConstants.defaultString
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    //-------------------------- The following methods all pertain to adjusting the view when the keyboar is present --------------------------
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) 
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //-------------------------- End of keyboard view methods ---------------------------------------------------------------------------------

}
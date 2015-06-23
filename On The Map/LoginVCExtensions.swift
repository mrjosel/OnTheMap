//
//  LoginVCExtensions.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension LoginViewController {
    
    func configureUI() {
        //Perform all default UI configuration
        
        //Udacity Orange Fade
        let lightOrange = UIColor(red: 1.125, green: 0.625, blue: 0.125, alpha: 1.0)
        var gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [lightOrange.CGColor, UIColor.orangeColor().CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        topvView.backgroundColor = UIColor.clearColor()
        
        //Login textFields, buttons
        bottomView.backgroundColor = UIColor.clearColor()
        let textFieldOrange = makeOrange()
        
        //set up usernameTextField appearence
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernameTextField.delegate = loginTextFieldDelegate
        usernameTextField.backgroundColor = textFieldOrange
        usernameTextField.textColor = UIColor.whiteColor()
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)  //indents text
        
        //set up passwordTextField appearence
        passwordTextField.delegate = loginTextFieldDelegate
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.backgroundColor = textFieldOrange
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)  //indents text
        
        //Udacity Image
        udacityIconImageView.contentMode = UIViewContentMode.ScaleAspectFill
        udacityIconImageView.image = UIImage(named: "Udacity")
        
        //Login Label
        loginLabel.textAlignment = NSTextAlignment.Center
        loginLabel.font = UIFont(name: "Roboto-Thin", size: 30.0)
        loginLabel.textColor = UIColor.whiteColor()
        loginLabel.text = "Login to Udacity"
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    func makeOrange() -> UIColor {
        //creates textfield orange color
        let rVal: CGFloat = 242
        let gVal: CGFloat = 192
        let bVal: CGFloat = 170
        
        let transRVal = rVal / 255
        let transGVal = gVal / 255
        let transBVal = bVal / 255
        
        return UIColor(red: transRVal, green: transGVal, blue: transBVal, alpha: 1.0)
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
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
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

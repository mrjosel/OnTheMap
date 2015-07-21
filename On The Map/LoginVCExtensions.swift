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
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

extension LoginViewController {
    
    func configureUI() {
        //Perform all default UI configuration
        
        //disable navbar
        self.navigationController?.navigationBarHidden = true
        
        let lightOrange = makeColor(255.0, gVal: 160.0, bVal: 32.0)
        let facebookBlue = makeColor(58, gVal: 86, bVal: 164)
        let facebookBlueHighlight = makeColor(35, gVal: 52, bVal: 104)
        var gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [lightOrange.CGColor, UIColor.orangeColor().CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        topvView.backgroundColor = UIColor.clearColor()
        
        //Sign-up button
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signUpButton.setTitle("Don't have an account? Sign Up.", forState: UIControlState.Normal)
        signUpButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 17.0)
        
        //Debug Label
        debugLabel.textAlignment = NSTextAlignment.Center
        debugLabel.font = UIFont(name: "Roboto-Medium", size: 17.0)
        debugLabel.textColor = UIColor.whiteColor()
        debugLabel.hidden = true
        
        //Login textFields, buttons
        bottomView.backgroundColor = UIColor.clearColor()
        
        //set up textField appearence
        setupTextFieldProperties(usernameTextField, placeholder: "Email")
        setupTextFieldProperties(passwordTextField, placeholder: "Password")

        //Udacity Image
        udacityIconImageView.contentMode = UIViewContentMode.ScaleAspectFill
        udacityIconImageView.image = UIImage(named: "Udacity")
        
        //Login Label
        loginLabel.textAlignment = NSTextAlignment.Center
        loginLabel.font = UIFont(name: "Roboto-Regular", size: 30.0)
        loginLabel.textColor = UIColor.whiteColor()
        loginLabel.text = "Login to Udacity"
        
        //Login Button
        loginButton.themeBorderedButton()
        
        //Facebook Button
        var facebookLoginButton: FBSDKLoginButton = FBSDKLoginButton()
        facebookLoginButton.delegate = self
        facebookLoginButton.frame = CGRect(x: 62.5, y: 552, width: 250.0, height: 44.0)
        self.view.addSubview(facebookLoginButton)
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
    
    func enableLoginElements(enabled: Bool) -> Void {
        //toggle user ability to use buttons/fields
        self.usernameTextField.enabled = enabled
        self.passwordTextField.enabled = enabled
        self.loginButton.enabled = enabled
        self.signUpButton.enabled = enabled
    }
    
    func setupTextFieldProperties(textField: UITextField, placeholder: String) -> Void {
        //common properties for each textField
        let textFieldOrange = makeColor(242, gVal: 192, bVal: 170)
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.font = UIFont(name: "Roboto-Regular", size: 17.0)
        textField.backgroundColor = textFieldOrange
        textField.textColor = UIColor.whiteColor()
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)  //indents text

    }
    
    func completeLogin() -> Void {
        //finish login procedure
        dispatch_async(dispatch_get_main_queue(), {
            //display TabBarVC
            let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarVC") as! UITabBarController
            //alert user
            self.debugLabel.text = "Loading Map..."
            self.presentViewController(tabBarVC, animated: true) {
                //Clear password and username
                self.debugLabel.text = ""
                self.enableLoginElements(true)
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
            }
        })
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

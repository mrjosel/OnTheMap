//
//  UIViewExtensions.swift
//  On The Map
//
//  Created by Brian Josel on 7/12/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //Common functions used amongst all view controllers
    
    func makeColor(rVal: CGFloat, gVal: CGFloat, bVal: CGFloat) -> UIColor {
        //creates color based on traditional 0 - 255 RGB Values
        //if any value is outside the range, UIColor initializers will handle adjusting the values
        
        let transRVal = rVal / 255
        let transGVal = gVal / 255
        let transBVal = bVal / 255
        
        return UIColor(red: transRVal, green: transGVal, blue: transBVal, alpha: 1.0)
    }
    
    func makeAlert(hostVC: UIViewController, title: String, error: NSError?) -> Void {
        //handler for OK button depending on VC
        var handler: ((alert: UIAlertAction!) -> (Void))?
        var messageText: String!
        
        if let error = error {
            messageText = error.localizedDescription
        } else {
            messageText = "Press OK to Continue"
        }
        
        //create UIAlertVC
        var alertVC = UIAlertController(title: title, message: messageText, preferredStyle: UIAlertControllerStyle.Alert)
        
        //set OK button handler depending on VC
        if hostVC.isKindOfClass(LoginViewController){
            let hostVC = hostVC as! LoginViewController
            //LoginVC
            handler = { alert in
                dispatch_async(dispatch_get_main_queue(), {
                    hostVC.debugLabel.text = ""
                    hostVC.enableLoginElements(true)
                    hostVC.usernameTextField.text = ""
                    hostVC.passwordTextField.text = ""
                })
            }
            
        } else if hostVC.isKindOfClass(InformationPostingViewController){
            //do infoPostVC suff
            let hostVC = hostVC as! InformationPostingViewController
            handler = { alert in
                    dispatch_async(dispatch_get_main_queue(), {
                        hostVC.searchField.text = hostVC.defaultString
                    })
                }
        } else {
            //is map or listVC
            handler = nil
        }
        
        //create action
        let ok = UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: handler)
        
        //add actions to alertVC
        alertVC.addAction(ok)
        dispatch_async(dispatch_get_main_queue(), {
            //present alertVC
            self.presentViewController(alertVC, animated: true, completion: nil)
        })
    }
}
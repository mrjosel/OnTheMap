//
//  LoginTextFieldDelegate.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

class LoginTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //hides keyboard when user hits enter
        textField.resignFirstResponder()
        return true
    }
}
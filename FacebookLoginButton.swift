//
//  FacebookLoginButton.swift
//  On The Map
//
//  Created by Brian Josel on 7/20/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

class FacebookLoginButton: BorderedButton {
    
    override func themeBorderedButton() -> Void {
        
        super.themeBorderedButton()
        
        //specific to this button
        self.highlightedBackingColor = UIColor(red: 0.13725, green: 0.20392, blue: 0.40784, alpha: 1.0)
        self.backingColor = UIColor(red: 0.22745, green: 0.33725, blue: 0.64314, alpha: 1.0)
        self.backgroundColor = UIColor(red: 0.22745, green: 0.33725, blue: 0.64314, alpha: 1.0)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setTitle("Sign in with Facebook", forState: UIControlState.Normal)
    }
}
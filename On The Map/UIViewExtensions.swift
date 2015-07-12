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
}
//
//  StoredPlaceholderTextField.swift
//  On The Map
//
//  Created by Brian Josel on 7/16/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

//UITextField with stored placeholder
class StoredPlaceholderTextField: UITextField {
    
    //stores the placeholder text
    var storedPlaceHolder: String
    
    required init(coder aDecoder: NSCoder) {
        storedPlaceHolder = ""
        super.init(coder: aDecoder)
    }
    
}
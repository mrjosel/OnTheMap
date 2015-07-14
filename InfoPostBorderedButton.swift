//
//  InfoPostBorderedButton.swift
//  On The Map
//
//  Created by Brian Josel on 7/14/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

class InfoPostBorderedButton: BorderedButton {
    override func themeBorderedButton() {
        super.themeBorderedButton()
        //specific to this button
        self.highlightedBackingColor = UIColor.whiteColor()
        self.backingColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.whiteColor()
        self.borderedButtonCornerRadius = 10.0
        self.setTitleColor(UIColor(red: 0.254902, green: 0.458824, blue: 0.643137, alpha: 1), forState: .Normal)
    }
}
//
//  BorderedButton.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//
//  CODE COPIED FROM UDACITY LESSON 2 MY FAVORITE MOVIES
//      Created by Jarrod Parkes on 1/23/15.
//      Copyright (c) 2015 Udacity. All rights reserved.

import UIKit

class BorderedButton: UIButton {
    
    /* Constants for styling and configuration */
    let darkerOrange = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha:1.0)
    let lighterOrange = UIColor(red: 1.0, green:0.35, blue:0.2, alpha: 1.0)
    let titleLabelFontSize : CGFloat = 17.0
    let borderedButtonHeight : CGFloat = 44.0
    var borderedButtonCornerRadius : CGFloat! //= 4.0
    let phoneBorderedButtonExtraPadding : CGFloat = 14.0
    
    var backingColor : UIColor? = nil
    var highlightedBackingColor : UIColor? = nil
    
    // MARK: - Initialization
    
    func themeBorderedButton() -> Void {

        self.highlightedBackingColor = darkerOrange
        self.backingColor = lighterOrange
        self.backgroundColor = lighterOrange
        self.borderedButtonCornerRadius = 4.0
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let userInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
        self.layer.masksToBounds = true
        self.layer.cornerRadius = borderedButtonCornerRadius
        self.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: titleLabelFontSize)
        
    }
    
    // MARK: - Setters
    
    private func setBackingColor(backingColor : UIColor) -> Void {
        if (self.backingColor != nil) {
            self.backingColor = backingColor;
            self.backgroundColor = backingColor;
        }
    }
    
    private func setHighlightedBackingColor(highlightedBackingColor: UIColor) -> Void {
        self.highlightedBackingColor = highlightedBackingColor
        self.backingColor = highlightedBackingColor
    }
    
    // MARK: - Tracking
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent: UIEvent) -> Bool {
        self.backgroundColor = self.highlightedBackingColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent: UIEvent) {
        self.backgroundColor = self.backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        self.backgroundColor = self.backingColor
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let userInterfaceIdiom = UIDevice.currentDevice().userInterfaceIdiom
        let extraButtonPadding : CGFloat = phoneBorderedButtonExtraPadding
        var sizeThatFits = CGSizeZero
        sizeThatFits.width = super.sizeThatFits(size).width + extraButtonPadding
        sizeThatFits.height = borderedButtonHeight
        return sizeThatFits
        
    }
}

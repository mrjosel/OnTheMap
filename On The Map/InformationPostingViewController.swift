//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Brian Josel on 7/11/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var findLocationButton: BorderedButton!
    
    //for keyboard adjustments
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    let blue = UIColor(red: 0.254902, green: 0.458824, blue: 0.643137, alpha: 1)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // get keybard notifications
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove keyboard notifications
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure tap recognizer */
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        self.tapRecognizer?.numberOfTapsRequired = 1
        
        //search button
        findLocationButton.themeBorderedButton("search")
        
        //textLabels
        self.topLabel.textColor = blue
        self.topLabel.font = UIFont(name: "Roboto-Thin", size: 25.0)
        
        self.midLabel.textColor = blue
        self.midLabel.font = UIFont(name: "Roboto-Medium", size: 25.0)
        
        self.bottomLabel.textColor = blue
        self.bottomLabel.font = UIFont(name: "Roboto-Thin", size: 25.0)
        
        //searchField configurations
        self.searchField.delegate = self
        self.searchField.text = "Enter Location Here"
        self.searchField.textColor = UIColor.whiteColor()
        self.searchField.font = UIFont(name: "Roboto-Medium", size: 17.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "Enter Location Here" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = "Enter Location Here"
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

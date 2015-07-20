//
//  LoginViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var udacityIconImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var topvView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!

    //for keyboard adjustments
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
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
        // Do any additional setup after loading the view, typically from a nib.
        
        //Configure the UI
        self.configureUI()

    }
    
    @IBAction func loginButtonTouchUpInside(sender: BorderedButton) {
        //complete login (get SessionID and UserID, clear username/password, launch map and list views, handle errors if necessary)
        
        //notify user of login activity, disable editing to username/textfields
        dispatch_async(dispatch_get_main_queue(), {
            self.enableLoginElements(false)
            self.debugLabel.text = "Logging in..."
            self.debugLabel.hidden = false
        })
        
        UdacityClient.sharedInstance().allActions(self.usernameTextField.text, password: self.passwordTextField.text) { success, error in
            if success {
                println("successful udacity actions")
                //get all studentObjects
                dispatch_async(dispatch_get_main_queue(), {
                    //alert user 
                    self.debugLabel.text = "Login Succesful, Getting User Data..."
                })
                ParseClient.sharedInstance().getStudentLocations() {success, error in
                    if success {
                        println("successful parseStudentObjects")
                        //complete login
                        self.completeLogin()
                    } else {
                        println("failed to get parse studentLocations")
                        //alert user
                        self.makeAlert(self, title: "Get User Data Failure", error: error!)
                    }
                }
            } else {
                println("failed udacity actions")
                //alert user
                self.makeAlert(self, title: "Login Failure", error: error!)
            }
        }
    }
    
    @IBAction func signUpButtonTouchUpInside(sender: UIButton) {
        //signup for Udacity
        
        UdacityClient.sharedInstance().udacitySignUp(self) {success, error in
            if success {
                println("successful signup")
                //show user its been a success
                self.debugLabel.text = "Successfully Signed up for Udacity!"
            } else {
                println("failed to signup")
                //alert user
                self.makeAlert(self, title: "Sign-Up Failure", error: error!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  LoginViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    //Outlets
    @IBOutlet weak var udacityIconImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var topvView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var udacityLoginButton: BorderedButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!

    //for keyboard adjustments
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    //email and password
    var email: String?
    var password: String?
//    var tokenString: String?
    
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
        println(self.passwordTextField.text)
        
        //Configure the UI
        self.configureUI()

        if let token = FBSDKAccessToken.currentAccessToken() {
            //facebook token present, get token string and login
//            tokenString = token.tokenString
            FacebookClient.sharedInstance().token = token
            self.loginButtonTouchUpInside(udacityLoginButton)
        }
    }
    
    @IBAction func loginButtonTouchUpInside(sender: BorderedButton) {
        //complete login (get SessionID and UserID, clear username/password, launch map and list views, handle errors if necessary)
        
        //notify user of login activity, disable editing to username/textfields
        dispatch_async(dispatch_get_main_queue(), {
            self.enableLoginElements(false)
            self.debugLabel.text = "Logging in..."
            self.debugLabel.hidden = false
        })
        
        self.getEmailPWfields()
        
        UdacityClient.sharedInstance().allActions() { success, error in
            if success {
                //get all studentObjects
                dispatch_async(dispatch_get_main_queue(), {
                    //alert user 
                    self.debugLabel.text = "Login Succesful, Getting User Data..."
                })
                ParseClient.sharedInstance().getStudentLocations() {success, error in
                    if success {
                        //complete login
                        self.completeLogin()
                    } else {
                        //alert user
                        self.makeAlert(self, title: "Get User Data Failure", error: error!)
                    }
                }
            } else {
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
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //execute the following when FBSDKLoginButton successfully logs in
        FacebookClient.sharedInstance().token = FBSDKAccessToken.currentAccessToken()
        self.loginButtonTouchUpInside(udacityLoginButton)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        //execute the following when FBSDKLoginButton successfully logs out
        //does nothing, only here for protocol conformity
        println("logged out of facebook")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  LoginViewController.swift
//  On The Map
//
//  Created by Brian Josel on 6/22/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
    
    let loginTextFieldDelegate = LoginTextFieldDelegate()
    
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
        
        //DEBUG REMOVE AT COMPLETION
        self.loginButtonTouchUpInside(self.loginButton)
    }
    
    @IBAction func loginButtonTouchUpInside(sender: BorderedButton) {
        //complete login (get SessionID and UserID, clear username/password, launch map and list views, handle errors if necessary)
        
        //notify user of login activity, disable editing to username/textfields
        dispatch_async(dispatch_get_main_queue(), {
            self.enableLoginElements(false)
            self.debugLabel.text = "Logging in..."
            self.debugLabel.hidden = false
        })
        UdacityClient.sharedInstance().getSessionID(usernameTextField.text, password: passwordTextField.text) {success, error in
            if success {    //sessionID and userID found
                println("Session ID = \(UdacityClient.sharedInstance().sessionID)")
                println("User ID = \(UdacityClient.sharedInstance().userID)")
                
                //alert user, remove lock on username/password fields
                dispatch_async(dispatch_get_main_queue(), {
                    self.debugLabel.text = "Login Successful.  Loading Map..."
                    self.enableLoginElements(true)
                })
//                self.dismissViewControllerAnimated(true, completion: nil)
                let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarVC") as! UITabBarController
                self.presentViewController(tabBarVC, animated: true, completion: nil)
            } else {    //failure retrieving userID and sessionID
                if let error = error {
                    var errorString = error.localizedDescription
                    println(errorString)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.debugLabel.text = errorString
                        self.enableLoginElements(true)
                    })
                }
            }
        }
    }
    
    @IBAction func signUpButtonTouchUpInside(sender: UIButton) {
        //TODO - Implement Sign Up Method
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


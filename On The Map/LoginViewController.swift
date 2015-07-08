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
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //alert user
                    self.debugLabel.text = "Login Successful.  Loading Map..."
                    
                    //display TabBarVC
                    let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarVC") as! UITabBarController
                    self.presentViewController(tabBarVC, animated: true) {
                        //Clear password and username
                        self.debugLabel.text = ""
                        self.enableLoginElements(true)
                        self.usernameTextField.text = ""
                        self.passwordTextField.text = ""
                    }
                })
            } else {    //failure retrieving userID and sessionID
                if let error = error {
                    
                    //create UIAlertVC
                    var alertVC = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    //create actions, OK does nothing, Cancel essentially "cleans slate"
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { handler in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.debugLabel.text = ""
                        })
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { handler in
                        //remove all login info and begin again
                        dispatch_async(dispatch_get_main_queue(), {
                            self.debugLabel.text = ""
                            self.enableLoginElements(true)
                            self.usernameTextField.text = ""
                            self.passwordTextField.text = ""
                        })
                    }
                    
                    //add actions to alertVC
                    alertVC.addAction(ok)
                    alertVC.addAction(cancel)
                    dispatch_async(dispatch_get_main_queue(), {
                        //print error, disable login elements, present alertVC
                        println(error.localizedDescription)
                        self.enableLoginElements(true)
                        self.presentViewController(alertVC, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    @IBAction func signUpButtonTouchUpInside(sender: UIButton) {
        //signup for Udacity
        
        UdacityClient.sharedInstance().udacitySignUp(self) {success, error in
            if let success = success {
                if success {
                    //show user its been a success
                    self.debugLabel.text = "Successfully Signed up for Udacity!"
                } else {
                    //alert user that some kind of error occurred
                    //create UIAlertVC
                    var alertVC = UIAlertController(title: "Sign-Up Failed", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    //create actions, OK dismissess alert
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { handler in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.debugLabel.text = ""
                        })
                    }
                    //add actions to alertVC
                    alertVC.addAction(ok)
                    dispatch_async(dispatch_get_main_queue(), {
                        //print error, disable login elements, present alertVC
                        println(error!.localizedDescription)
                        self.enableLoginElements(true)
                        self.presentViewController(alertVC, animated: true, completion: nil)
                    })
                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


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
    }
    
    @IBAction func loginButtonTouchUpInside(sender: BorderedButton) {
        dispatch_async(dispatch_get_main_queue(), {
            self.enableLoginElements(false)
            self.debugLabel.text = "Logging in..."
            self.debugLabel.hidden = false
        })
        UdacityClient.sharedInstance().getSessionID(usernameTextField.text, password: passwordTextField.text) {success, error in
            if success {
                println("Session ID = \(UdacityClient.sharedInstance().sessionID)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.debugLabel.text = "Login Successful.  Loading Map..."
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                    self.enableLoginElements(true)
                })
            } else {
                if let error = error {
                    println("Login Failed.  (Session ID)")
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


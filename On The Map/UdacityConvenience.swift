//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Brian Josel on 6/24/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func allActions(email: String, password: String, completionHandler:(success: Bool, error: NSError?) -> Void) {
        // Use email and password to POST and get JSON data
        let method = Methods.SESSION
        let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        //POST Method
        let task = taskForPOSTMethod(method, body: httpBody!) {success, result, error in
            if success {
                println("taskForPOST successful")
                // successfully retrieved JSON data, cast it to [String: AnyObject]
                if let validJSONData = result as? [String: AnyObject] {
                    println("valid casting of JSON data")
                    //check valid credentials
                    self.checkValidCredentials(validJSONData) {success, error in
                        if success {
                            println("verified credentials")
                            //get sessionID and userID
                            self.getSessionID(validJSONData) {success, error in
                                if success {
                                    println("successfull got sessionID")
                                    completionHandler(success: true, error: nil)
                                } else {
                                    println("failed to get sessionID")
                                    completionHandler(success: false, error: error)
                                }
                            }
                        } else {
                            println("failed to verify credentials")
                            completionHandler(success: false, error: error)
                        }
                    }
                } else {
                    println("failed to cast JSON")
                    completionHandler(success: false, error: self.errorHandle("casting validJSONData", errorString: "Error: Failed to Cast JSON Data"))
                }
            } else {
                println("taskForPOST failed")
                completionHandler(success: false, error: error)
            }
        }
    }
    
    func getUserPublicData(userID: String?, completionHandler:(successs: Bool, error: NSError?) -> Void) {
        //gets user data from Udacity
        
        //configure urlString
        let urlString = Constants.BASE_URL + Constants.API + "/" + UdacityClient.sharedInstance().userID!
        
        taskForGETMethod(urlString){ success, result, error in
            if let error = error {
                //handle error
                completionHandler(successs: false, error: self.errorHandle("getUserPublicData", errorString: "Failed to Get User Data"))
            } else {
                //get first and last names
                if let result = result as? [String: AnyObject] {
                    if let userInfo = result[UdacityClient.UserKeys.USER] as? [String: AnyObject] {
                        self.firstName = (userInfo[UdacityClient.UserKeys.FIRST_NAME] as! String)
                        self.lastName = (userInfo[UdacityClient.UserKeys.LAST_NAME] as! String)
                    } else {
                        //handler error
                        completionHandler(successs: false, error: self.errorHandle("getUserPublicData", errorString: "Failed to Get User Data"))
                    }
                } else {
                    
                    completionHandler(successs: false, error: self.errorHandle("getUserPublicData", errorString: "Failed to Get User Data"))
                }
            }
        }
        
    }
    
    func getSessionID(JSONData: [String: AnyObject], completionHandler: (success: Bool, error: NSError?) -> Void) {
        //parse JSON data to get sessionID
        if let session = JSONData[JSONBodyKeys.SESSION] as? [String: AnyObject] {
            if let sessionID = session[JSONBodyKeys.ID] as? String {
                //Session ID Found, store in var, report success to completionHandler
                self.sessionID = sessionID
                completionHandler(success: true, error: nil)
            } else {
                //No ID key/val pair in data, need to generate error
                completionHandler(success: false, error: self.errorHandle("getSessionID", errorString: "Error: \(JSONBodyKeys.ID) Not Found"))
            }
        } else {
            //no Session key/val pair in data, need to generate error
            completionHandler(success: false, error: self.errorHandle("getSessionID", errorString: "Error: \(JSONBodyKeys.SESSION) Not Found"))
        }
    }
    
    func checkValidCredentials(JSONData: [String:AnyObject], completionHandler: (valid: Bool, error: NSError?) -> Void) -> Void {
        //Check if login credentials are valid
        
        //perform the check based on parsed JSON data
        if let error = JSONData[JSONBodyKeys.ERROR] as? String {
            //error field is present in data
            let statusCode = JSONData[JSONBodyKeys.STATUS] as! Int
            switch statusCode {
            case 403:   //incorrect credentials
                completionHandler(valid: false, error: errorHandle("checkValidCredentials", errorString: error))
            case 400:   //missing username and/or password - error is generalized rather than calling specific missing field
                completionHandler(valid: false, error: errorHandle("checkValidCredentials", errorString: "Missing Email and/or Password"))
            default:
                //some other error
                completionHandler(valid: false, error: errorHandle("checkValidCredentials", errorString: "Error: \(JSONBodyKeys.STATUS) = \(JSONData[JSONBodyKeys.STATUS]!)"))
            }
        } else {
            //error field not present in data
            if let account = JSONData[JSONBodyKeys.ACCOUNT] as? [String: AnyObject] {
                if let registered = account[JSONBodyKeys.REGISTERED] as? Int {
                    //checking if user is registered
                    if registered == 1 {
                        //user is registered
                        let key = account[JSONBodyKeys.KEY] as! String
                        self.userID = key
                        completionHandler(valid: true, error: nil)
                    } else {
                        //credentials valid, but some other error
                        completionHandler(valid: false, error: errorHandle("checkValidCredentials", errorString: "Error: \(JSONBodyKeys.REGISTERED) = \(registered)"))
                    }
                } else {
                    //registered field not found
                    completionHandler(valid: false, error: errorHandle("checkValidCredentials", errorString: "Error: \(JSONBodyKeys.REGISTERED) does not exist"))
                }
            } else {
                //account field not found
                completionHandler(valid: false, error: errorHandle("checkValidCredentials", errorString: "Error: \(JSONBodyKeys.ACCOUNT) does not exist"))
            }
        }
    }   
    
    func udacitySignUp(hostViewController: UIViewController, completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        //method for signup
        
        //create signup  URL, make request
        let signupURL = NSURL(string: "\(UdacityClient.Constants.BASE_URL)\(UdacityClient.Constants.SIGN_UP)")
        let request = NSURLRequest(URL: signupURL!)
        
        //create webviewVC, add URL and Request
        let signupVC = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("SignUpWebVC") as! UdacitySignUpWebViewController
        signupVC.urlRequest = request
        signupVC.completionHandler = completionHandler
        
        //create NavCtrler, have NavCtrler push webView when present
        let webNavController = UINavigationController()
        webNavController.pushViewController(signupVC, animated: false)
        
        //present NavCtrler
        dispatch_async(dispatch_get_main_queue(), {
            hostViewController.presentViewController(webNavController, animated: true, completion: nil)
        })
    }
    
    func udacityLogout(completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        let task = taskForDELETEMethod(UdacityClient.Methods.SESSION, request: NSMutableURLRequest()) {success, result, error in
            if let error = error {
                //TODO - Make Alert VC to display error
                println("error found")
                completionHandler(success: false, error: self.errorHandle("udacityLogout", errorString: error.localizedDescription))
            } else {
                if let session = result?.valueForKey(JSONBodyKeys.SESSION) as? [String: AnyObject] {
                    if let expiration = session[JSONBodyKeys.EXPIRATION] as? String {
                        //clear IDs, report success
                        self.clearIDs()
                        completionHandler(success: true, error: nil)
                    } else {
                        completionHandler(success: false, error: self.errorHandle("udacityLogout", errorString: "Error: \(JSONBodyKeys.EXPIRATION) does not exist"))
                    }
                } else {
                    //TODO - Make Alert VC to display error
                    println("session not found")
                    completionHandler(success: false, error: self.errorHandle("udacityLogout", errorString: "Error: \(JSONBodyKeys.SESSION) does not exist"))
                }
            }
        }
    }

    func errorHandle(domain: String, errorString: String) -> NSError {
        //Create specialized errors in cases of elements not existing in successfully retrieved JSON data
        return NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "\(errorString)"])
    }
}
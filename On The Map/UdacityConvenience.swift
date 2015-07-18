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
        
        //execute one post method to get all required information as there are no specific methods for each
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
                                    self.getUserPublicData(self.userID) {success, error in
                                        if success {
                                            println("successfully got user public data")
                                            completionHandler(success: true, error: nil)
                                        } else {
                                            println("faild to get user public data")
                                            completionHandler(success: false, error: error)
                                        }
                                    }
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
        let urlString = Constants.BASE_URL + Constants.API + Constants.USERS + "/" + UdacityClient.sharedInstance().userID!
        println("test string = https://www.udacity.com/api/users/3903878747")
        println("              \(urlString)")
        taskForGETMethod(urlString){ success, result, error in
            if let error = error {
                //handle error
                println("println failed to get data in user public data")
                completionHandler(successs: false, error: self.errorHandle("getUserPublicData", errorString: "Failed to Get User Data"))
            } else {
                //get first and last names
                println("successful data retrieval")
                if let result = result as? [String: AnyObject] {
                    println("successfully parsed result")
                    println("USERKEY = \(UdacityClient.UserKeys.USER)")
                    println("\n \(result) \n")
                    if let userInfo = result[UdacityClient.UserKeys.USER] as? [String: AnyObject] {
                        println("successfully print parsed userInfo")
                        self.firstName = (userInfo[UdacityClient.UserKeys.FIRST_NAME] as! String)
                        self.lastName = (userInfo[UdacityClient.UserKeys.LAST_NAME] as! String)
                        println("firstName = \(self.firstName)")
                        println("firstName = \(self.lastName)")
                        completionHandler(successs: success, error: nil)
                    } else {
                        //handler error
                        println("failed to parse userInfo")
                        completionHandler(successs: false, error: self.errorHandle("getUserPublicData", errorString: "Failed to Get User Data"))
                    }
                } else {
                    println("failed to parse result")
                    completionHandler(successs: false, error: self.errorHandle("getUserPublicData", errorString: "Failed to Get User Data"))
                }
            }
        }
        
    }
    
    //get SessionID from JSON
    func getSessionID(JSONData: [String: AnyObject], completionHandler: (success: Bool, error: NSError?) -> Void) {
        //check if session present in data
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
                println(account)
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
    
    //logout of app using udacity API
    func udacityLogout(completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        taskForDELETEMethod(UdacityClient.Methods.SESSION, request: NSMutableURLRequest()) {success, result, error in
            if let error = error {
                //failed DELETE method
                completionHandler(success: false, error: self.errorHandle("udacityLogout", errorString: error.localizedDescription))
            } else {
                //successful DELETE method
                if let session = result?.valueForKey(JSONBodyKeys.SESSION) as? [String: AnyObject] {
                    //session found
                    if let expiration = session[JSONBodyKeys.EXPIRATION] as? String {
                        //expirmation found, clear IDs, studentLocation objects, report success
                        self.clearIDs()
                        ParseClient.sharedInstance().clearStudentLocations()
                        completionHandler(success: true, error: nil)
                    } else {
                        //expiration not found
                        completionHandler(success: false, error: self.errorHandle("udacityLogout", errorString: "Error: \(JSONBodyKeys.EXPIRATION) does not exist"))
                    }
                } else {
                    //session not found
                    completionHandler(success: false, error: self.errorHandle("udacityLogout", errorString: "Error: \(JSONBodyKeys.SESSION) does not exist"))
                }
            }
        }
    }
}
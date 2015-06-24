//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Brian Josel on 6/24/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

extension UdacityClient {
    func checkValidCredentials(JSONData: [String:AnyObject], completionHandler: (valid: Bool, error: NSError?) -> Void) -> Void {
        //TODO - Better More Intelligent Error Handling
        
        //Check if login credentials are valid

        //possible errors
        let someOtherError = NSError(domain: "Login Credentials", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Error"])
        
        //perform the check based on parsed JSON data
        if let error = JSONData[JSONBodyKeys.ERROR] as? String {
            //error field is present in data
            if JSONData[JSONBodyKeys.STATUS] as! Int == 403 {
                //status code reflects bad credentials or invalid account
                let credentialsError = NSError(domain: "Login Credentials", code: 0, userInfo: [NSLocalizedDescriptionKey: error])
                completionHandler(valid: false, error: credentialsError)
            } else {
                //some other error
                completionHandler(valid: false, error: someOtherError)
            }
        } else {
            //error field not present in data
            if let account = JSONData[JSONBodyKeys.ACCOUNT] as? [String: AnyObject] {
                if let registered = account[JSONBodyKeys.REGISTERED] as? Int {
                    //checking if user is registered
                    if registered == 1 {
                        //user is registered
                        completionHandler(valid: true, error: nil)
                    } else {
                        //credentials valid, but some other error
                        completionHandler(valid: false, error: someOtherError)
                    }
                } else {
                    completionHandler(valid: false, error: someOtherError)
                }
            } else {
                completionHandler(valid: false, error: someOtherError)
            }
        }
    }
}
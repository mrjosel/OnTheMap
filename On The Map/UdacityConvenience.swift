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
    
    func errorHandle(domain: String, errorString: String) -> NSError {
        //Create specialized errors in cases of elements not existing in successfully retrieved JSON data
        return NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "\(errorString)"])
    }
}
//
//  FacebookClient.swift
//  On The Map
//
//  Created by Brian Josel on 7/18/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class FacebookClient: GenericClient {
    
    func facebookLogin() {
        
        let token = FBSDKAccessToken.currentAccessToken().tokenString
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(token)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error...
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            self.parseJSON(newData) { success, result, error in
                if let error = error {
                    println(error)
                } else {
                    println(result as! [String:AnyObject])
                }
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> FacebookClient {
        //create shared instance
        
        struct Singleton {
            static var sharedInstance = FacebookClient()
        }
        
        return Singleton.sharedInstance
    }
}
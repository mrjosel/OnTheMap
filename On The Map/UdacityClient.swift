//
//  UdacityClient.swift
//  On The Map
//
//  Created by Brian Josel on 6/23/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

class UdacityClient: AnyObject {
    
    var sessionID: String?
    
    func getSessionID(email: String, password: String, completionHandler: (success: Bool, error: NSError?) -> Void) {
        //construct URL
        let urlString = Constants.BASE_URL + Constants.API + Methods.SESSION
        let url = NSURL(string: urlString)
        
        //create session
        let session = NSURLSession.sharedSession()
        
        //create and configure request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        //start request
        let task = session.dataTaskWithRequest(request) {data, response, parsingError in
            if let error = parsingError {
                completionHandler(success: false, error: error)
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                var parsedData = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as! [String: AnyObject]
                //Check for valid credentials
                self.checkValidCredentials(parsedData) {success, error in
                    if success {    //successfully verified credentials
                        let dataNotFound = NSError(domain: "parsing sessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "sessionID not found"])
                        if let session = parsedData[JSONBodyKeys.SESSION] as? [String: AnyObject] {
                            if let id = session[JSONBodyKeys.ID] as? String {
                                //Session ID Found, store in var, report success to completionHandler
                                self.sessionID = id
                                completionHandler(success: true, error: nil)
                            } else {
                                //No ID key/val pair in data
                                completionHandler(success: false, error: dataNotFound)
                            }
                        } else {
                            //no Session key/val pair in data
                            completionHandler(success: false, error: dataNotFound)
                        }
                    } else {
                        //Login Credentials Failed
                        completionHandler(success: false, error: error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> UdacityClient {
        //create shared instance
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}

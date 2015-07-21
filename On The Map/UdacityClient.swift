//
//  UdacityClient.swift
//  On The Map
//
//  Created by Brian Josel on 6/23/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

class UdacityClient: GenericClient {
    
    //email and password
    var email: String?
    var password: String?
    
    //session and user ID
    var sessionID: String?
    var userID: String?
    
    //user's first and last name
    var firstName: String?
    var lastName: String?
    
    func clearIDs() -> Void {
        //Clear out IDs after logging out
        sessionID = nil
        userID = nil
        email = nil
        password = nil
    }
    
    func taskForGETMethod(urlString: String, completionHandler: (success: Bool, result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionTask {
        
        //construct URL
        let url = NSURL(string: urlString)
        
        //create session
        let session = NSURLSession.sharedSession()
        
        //create request
        let request = NSMutableURLRequest(URL: url!)
        
        //start request
        let task = session.dataTaskWithRequest(request) {data, response, parsingError in
            if let error = parsingError {
                completionHandler(success: false, result: nil, error: error)
            } else {
                let data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                self.parseJSON(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    func taskForPOSTMethod(method: String, body: NSData, completionHandler: (success: Bool, result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionTask {
        
        //create and configure request
        let request = NSMutableURLRequest() //URL completed in POST method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = body
        
        //construct URL
        let urlString = Constants.BASE_URL + Constants.API + method
        let url = NSURL(string: urlString)
        
        //create session
        let session = NSURLSession.sharedSession()
        
        //finish configuration
        request.URL = url!
        request.HTTPMethod = "POST"
        
        
        //start request
        let task = session.dataTaskWithRequest(request) {data, response, parsingError in
            if let error = parsingError {
                //error posing
                completionHandler(success: false, result: nil, error: error)
            } else {
                //successfully posted
                let data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                self.parseJSON(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    func taskForDELETEMethod(method: String, request: NSMutableURLRequest, completionHandler: (success: Bool, result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionTask {

        //construct URL
        let urlString = Constants.BASE_URL + Constants.API + method
        let url = NSURL(string: urlString)

        //create session
        let session = NSURLSession.sharedSession()
        
        //finish configuration
        request.URL = url!
        request.HTTPMethod = "DELETE"
        
        //find cookie and add to request
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            //add cookie to request if found
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
    
        //start request
        let task = session.dataTaskWithRequest(request) {data, response, parsingError in
            if let error = parsingError {
                //failed DELETE
                completionHandler(success: false, result: nil, error: error)
            } else {
                //successfull DELETE
                let data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                self.parseJSON(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }

    class func sharedInstance() -> UdacityClient {
        //create shared instance
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}

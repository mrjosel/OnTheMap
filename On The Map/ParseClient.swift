//
//  ParseClient.swift
//  On The Map
//
//  Created by Brian Josel on 6/23/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

class ParseClient: GenericClient {
    
    var studentLocations: [ParseStudentLocation] = []
    
    //method for GET
    func taskForGETMethod(urlString: String, completionHandler: (success: Bool, result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionTask {
        
        //construct URL
        let url = NSURL(string: urlString)
        
        //create session
        let session = NSURLSession.sharedSession()
        
        //create request
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(ParseClient.Constants.APPLICATIONID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //start request
        let task = session.dataTaskWithRequest(request) {data, response, parsingError in
            if let error = parsingError {
                //error in GET
                completionHandler(success: false, result: nil, error: error)
            } else {
                //no error
                self.parseJSON(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    func taskForPOSTMethod(urlString: String, httpBody: NSData, completionHandler: (success: Bool, result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionTask {
        
        //construct URL
        let url = NSURL(string: urlString)
        
        //create session
        let session = NSURLSession.sharedSession()
        
        //create request
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(ParseClient.Constants.APPLICATIONID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBody
        request.HTTPMethod = "POST"
        
        //start request
        let task = session.dataTaskWithRequest(request) {data, response, parsingError in
            if let error = parsingError {
                //POST error
                completionHandler(success: false, result: nil, error: error)
            } else {
                //no error
                self.parseJSON(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }
    
    class func sharedInstance() -> ParseClient {
        //create shared instance
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }

}
//
//  ParseClient.swift
//  On The Map
//
//  Created by Brian Josel on 6/23/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation


class ParseClient: AnyObject {
    
    var studentLocations: [ParseStudentLocation] = []
    
    func getStudentLocations(completionHandler: (success: Bool!, result: AnyObject?, error: NSError?) -> Void) -> Void {
        
        //error
        var parsingError: NSError? = nil
        
        //set URL
        let urlString = ParseClient.URLs.BASEURL + ParseClient.methods.STUDENT_LOCATION
        let url = NSURL(string: urlString)
        
        //configure request
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(ParseClient.Constants.APPLICATIONID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //start session
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let error = error {
                completionHandler(success: false, result: nil, error: error)
            } else {
                if let parsedJSONdata = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject] {
                    completionHandler(success: true, result: parsedJSONdata, error: nil)
                }
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> ParseClient {
        //create shared instance
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }

}
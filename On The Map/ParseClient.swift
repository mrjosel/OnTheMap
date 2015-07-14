//
//  ParseClient.swift
//  On The Map
//
//  Created by Brian Josel on 6/23/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import UIKit


class ParseClient: AnyObject {
    
    var studentLocations: [ParseStudentLocation] = []
    
    //method to get student locations
    func getStudentLocations(completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        
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
                completionHandler(success: false, error: error)
            } else {
                if let parsedJSONdata = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject] {
                    self.makeStudentLocationObjectsFromData(parsedJSONdata)
                    completionHandler(success: true, error: nil)
                }
            }
        }
        task.resume()
    }
    
    func postStudentLocation(completionHandler: (success: Bool!, result: AnyObject?, error: NSError?) -> Void) -> Void {
        
        //parse uniqueKey = Udacity UserID, first name and last name of user
        let uniqueKey = UdacityClient.sharedInstance().userID
        let firstName = UdacityClient.sharedInstance().firstName
        let lastName = UdacityClient.sharedInstance().lastName
        
        //error
        var parsingError: NSError? = nil
        
        //set URL
        let urlString = ParseClient.URLs.BASEURL + ParseClient.methods.STUDENT_LOCATION
        let url = NSURL(string: urlString)
        
        //configure request
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(ParseClient.Constants.APPLICATIONID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //post request
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        //start session
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    func makeStudentLocationObjectsFromData(parsedJSONData: [String: AnyObject]) {
        //get array of studentLocation dicts
        var studentLocationsDict = parsedJSONData[ParseClient.ParameterKeys.RESULTS] as! [[String: AnyObject]]
        
        //create studentLocation object for every dict in array, append to sharedInstance variable, then sort by last name
        for studentLocation in studentLocationsDict {
            ParseClient.sharedInstance().studentLocations.append(ParseStudentLocation(parsedJSONdata: studentLocation))
            ParseClient.sharedInstance().studentLocations.sort({ $0.lastName < $1.lastName })
        }
    }
    
    class func sharedInstance() -> ParseClient {
        //create shared instance
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }

}
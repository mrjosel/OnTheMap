//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Brian Josel on 7/16/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

extension ParseClient {
    //method to get student locations
    func getStudentLocations(completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
        
        //set URL
        let urlString = ParseClient.URLs.BASEURL + ParseClient.methods.STUDENT_LOCATION
        
        //begin getMethod
        let task = taskForGETMethod(urlString) { success, result, error in
            if let error = error {
                //get method failed
                println("get method failed")
                completionHandler(success: false, error: error)
            } else {
                //get method suceeded
                println("get method success")
                if let parsedJSONdata = result as? [String:AnyObject] {
                    println("json casting success")
                    //clear out student locations
                    self.studentLocations = []
                    println(self.studentLocations.count)
                    //make studentLocations from data
                    self.makeStudentLocationObjectsFromData(parsedJSONdata)
                    println(self.studentLocations.count)
                    completionHandler(success: true, error: nil)
                } else {
                    //casting failed
                    println("json casting failed")
                    completionHandler(success: false, error: self.errorHandle("getStudentLocations", errorString: "Casting Data Failed"))
                }
            }
        }
    }
    
    func postStudentLocation(locationString: String, latitude: Double, longitude: Double, userURLstring: String, completionHandler: (success: Bool, /*result: AnyObject?,*/ error: NSError?) -> Void) -> Void {
        
        //parse uniqueKey = Udacity UserID, first name and last name of user
        let uniqueKey = UdacityClient.sharedInstance().userID!
        let firstName = UdacityClient.sharedInstance().firstName!
        let lastName = UdacityClient.sharedInstance().lastName!
        
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
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationString)\", \"mediaURL\": \"\(userURLstring)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        println(userURLstring)
        //start session
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let requestError = error {
                println("failed to get JSON")
                completionHandler(success: false, error: requestError)
            } else {
                println("successful JSON")
                if let parsedJSONdata = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String: AnyObject] {
                    if let error = parsedJSONdata["error"] as? String {
                        println("parsed JSON has error")
                        println(parsedJSONdata)
                        completionHandler(success: false, error: NSError(domain: error, code: 0, userInfo: nil))
                    } else if let createdAt = parsedJSONdata["createdAt"] as? String {
                        println("we have a winner")
                        println(createdAt)
                        completionHandler(success: true, error: nil)
                    }
                } else {
                    println("couldn't parse JSON")
                    completionHandler(success: false, error: NSError(domain: "wut", code: 0, userInfo: nil))
                }
            }
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
}

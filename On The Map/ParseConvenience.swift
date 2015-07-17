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
                    //check for error field
                    println("json casting success")
                    if let errorString = parsedJSONdata[ParseClient.ParameterKeys.ERROR] as? String {
                        //error found
                        println("error found: \(errorString)")
                        completionHandler(success: false, error: self.errorHandle("getStudentLocations", errorString: errorString))
                    } else {
                        //no error found, clear out student locations
                        self.studentLocations = []
                        println(self.studentLocations.count)
                        //make studentLocations from data
                        self.makeStudentLocationObjectsFromData(parsedJSONdata)
                        println(self.studentLocations.count)
                        completionHandler(success: true, error: nil)
                    }
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
        
        //set URL
        let urlString = ParseClient.URLs.BASEURL + ParseClient.methods.STUDENT_LOCATION

        //set up httpBody
        let httpBody: NSData = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationString)\", \"mediaURL\": \"\(userURLstring)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)!
        
        //start post method
        let task = taskForPOSTMethod(urlString, httpBody: httpBody) { success, result, error in
            if let error = error {
                //post method failure
                completionHandler(success: false, error: error)
            } else {
                //successful post method, cast result as dict
                if let parsedJSONdata = result as? [String: AnyObject] {
                    //check for error
                    if let errorString = parsedJSONdata[ParseClient.ParameterKeys.ERROR] as? String {
                        //result has error
                        completionHandler(success: false, error: self.errorHandle("postStudentLocation", errorString: errorString))
                    } else {
                        //no error, check for user info
                        if let createdAt = parsedJSONdata[ParseClient.ParameterKeys.CREATED_AT] as? String {
                            completionHandler(success: true, error: nil)
                        } else {
                            //createdAt field not found
                            completionHandler(success: false, error: self.errorHandle("postStudentLocation", errorString: "Failed to Get Confirmation"))
                        }
                    }
                } else {
                    //casting failed
                    completionHandler(success: false, error: self.errorHandle("postStudentLocation", errorString: "Failed to Cast Data"))
                }
            }
        }
    }
    
    func makeStudentLocationObjectsFromData(parsedJSONData: [String: AnyObject]) {
        println("making studentLocation objects")
        println(parsedJSONData)
        //get array of studentLocation dicts
        var studentLocationsDict = parsedJSONData[ParseClient.ParameterKeys.RESULTS] as! [[String: AnyObject]]
        //create studentLocation object for every dict in array, append to sharedInstance variable, then sort by last name
        for studentLocation in studentLocationsDict {
            ParseClient.sharedInstance().studentLocations.append(ParseStudentLocation(parsedJSONdata: studentLocation))
            ParseClient.sharedInstance().studentLocations.sort({ $0.lastName < $1.lastName })
        }
    }
}

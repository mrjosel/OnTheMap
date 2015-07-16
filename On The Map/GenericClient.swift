//
//  GenericClient.swift
//  On The Map
//
//  Created by Brian Josel on 7/16/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

class GenericClient: AnyObject {
    
    func parseJSON(data: NSData, completionHandler: (success: Bool, result: AnyObject?, error: NSError?) -> Void) -> Void {
        //error for pointer
        var parsingError: NSError? = nil
        
        var parsedData: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(success: false, result: nil, error: self.errorHandle("parseJSON", errorString: "JSON Parsing Error"))
        } else {
            completionHandler(success: true, result: parsedData, error: nil)
        }
        
    }
    
    func errorHandle(domain: String, errorString: String) -> NSError {
        //Create specialized errors in cases of elements not existing in successfully retrieved JSON data
        return NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey: "\(errorString)"])
    }
}
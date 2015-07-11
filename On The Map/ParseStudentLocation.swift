//
//  ParseStudentLocation.swift
//  On The Map
//
//  Created by Brian Josel on 7/10/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

struct ParseStudentLocation {       //Struct for Student Location objects
    
    //parameters
    var createdAt:  String?      //not required as per documentaion
    var firstName:  String?
    var lastName:   String?
    var latitude:   Double?
    var longitude:  Double?
    var mapString:  String?
    var mediaUrl:   String?
    var objectID:   String?
    var uniqueKey:  String?
    var updatedAt:  String?      //not required as per documentaion
    
    init(parsedJSONdata: [String: AnyObject]) {
        
        //create Student Location object from JSON data, assume sucessful parsing of JSON data
        createdAt   =   parsedJSONdata[ParseClient.ParameterKeys.CREATED_AT]    as? String
        firstName   =   parsedJSONdata[ParseClient.ParameterKeys.FIRST_NAME]    as? String
        lastName    =   parsedJSONdata[ParseClient.ParameterKeys.LAST_NAME]     as? String
        latitude    =   parsedJSONdata[ParseClient.ParameterKeys.LAT]           as? Double
        longitude   =   parsedJSONdata[ParseClient.ParameterKeys.LON]           as? Double
        mapString   =   parsedJSONdata[ParseClient.ParameterKeys.MAP_STRING]    as? String
        mediaUrl    =   parsedJSONdata[ParseClient.ParameterKeys.MEDIA_URL]     as? String
        objectID    =   parsedJSONdata[ParseClient.ParameterKeys.OBJECT_ID]     as? String
        uniqueKey   =   parsedJSONdata[ParseClient.ParameterKeys.UNIQUE_KEY]    as? String
        updatedAt   =   parsedJSONdata[ParseClient.ParameterKeys.UPDATED_AT]    as? String
    }
}

extension ParseStudentLocation: Printable {
    
    var description: String {
        get {
            return ("\(lastName), \(firstName)")
        }
    }
}
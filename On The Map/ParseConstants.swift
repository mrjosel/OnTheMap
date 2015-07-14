//
//  ParseConstants.swift
//  On The Map
//
//  Created by Brian Josel on 6/23/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

extension ParseClient {
    struct Constants {//All constants related to API
        
        //API Key and Application ID
        static let APIKEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let APPLICATIONID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct URLs {
        //URLs
        static let BASEURL = "https://api.parse.com/1/classes/"
    }
    
    struct methods {
        //methods
        static let STUDENT_LOCATION = "StudentLocation/"
    }
    
    struct ParameterKeys {
        
        //initial key for all results
        static let RESULTS = "results"
        
        //keys in Student Location Objects
        static let CREATED_AT = "createdAt"     //not required as per Parse documentation supplied by course
        static let FIRST_NAME = "firstName"
        static let LAST_NAME = "lastName"
        static let LAT = "latitude"
        static let LON = "longitude"
        static let MAP_STRING = "mapString"
        static let MEDIA_URL = "mediaURL"
        static let OBJECT_ID = "objectId"
        static let UNIQUE_KEY = "uniqueKey"
        static let UPDATED_AT = "updatedAt"     //not required as per Parse documentation supplied by course
    }
}
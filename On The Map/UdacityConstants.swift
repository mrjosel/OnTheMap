//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Brian Josel on 6/23/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    //all constants of Udacity Client
    struct Constants {
        
        //Optional Facebook ID
        static let FACEBOOK_ID = "365362206864879"
        
        //URLs
        static let BASE_URL = "https://www.udacity.com"
        static let API = "/api"
        static let SIGN_IN = "account/auth#!/signin/"
    }
    
    //Available methods
    struct Methods {
        static let SESSION = "/session"
        static let USERS = "/users"
    }
    
    struct URLKeys {
        let USER_ID = "id"
    }
    
    //Parameter Keys
    struct ParameterKeys {
        
        static let SESSION_ID = "session_id"
        
    }
    
    struct JSONBodyKeys {
        static let SESSION = "session"
        static let EXPIRATION = "expiration"
        static let ID = "id"
        static let ACCOUNT = "account"
        static let KEY = "key"
        static let REGISTERED = "registered"
        static let STATUS = "status"
        static let ERROR = "error"
    }
}
//
//  FacebookClient.swift
//  On The Map
//
//  Created by Brian Josel on 7/18/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookClient: GenericClient {
    
    var token: FBSDKAccessToken?
    let manager = FBSDKLoginManager()
    
    class func sharedInstance() -> FacebookClient {
        //create shared instance
        
        struct Singleton {
            static var sharedInstance = FacebookClient()
        }
        
        return Singleton.sharedInstance
    }
}
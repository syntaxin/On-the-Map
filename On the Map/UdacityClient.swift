//
//  UdacityClient.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.


import Foundation

class UdacityClient : NSObject {

    /* Shared session */
    var session: NSURLSession

    /* Session information*/
    var sessionID : String? = nil
    var sessionExpiration: String? = nil
    var accountKey: String? = nil
    var accountRegistered: Bool? = nil
    
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
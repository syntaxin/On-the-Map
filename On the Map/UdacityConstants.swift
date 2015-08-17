//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        
        //FacebookAppID
        static let FacebookAppID : String = "5626336eb68e2365362206864879"
        //URLs
        static let BaseURL : String = "https://www.udacity.com/api/"
    }
    
    //Methods
    struct Methods {
        
        //Session
        static let Session = "session"        
        //Users
        static let Users = "users"

        
    }
    
    //URL Keys
    struct URLKeys {
        
        static let userID = "user_id"
        
    }
    
    
    // JSON Body Keys
    struct JSONBodyKeys {
        
        static let username = "username"
        static let password = "password"
        
    }
    
    // JSON Response Keys
    struct JSONResponseKeys {
        
        // Authorization
        static let SessionId = "id"
        static let Expiration  = "expiration"
        
        
        // Account
        static let Registered = "registered"
        static let Key = "key"
        
    }
}


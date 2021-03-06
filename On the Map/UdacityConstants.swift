//
//  UdacityConstants.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

extension UdacityClient {

    
/* Constants for the Udacity API */
    
    struct Constants {
        
        //FacebookAppID
        static let FacebookAppID : String = "5626336eb68e2365362206864879"
        //URLs
        static let BaseURL : String = "https://www.udacity.com/api/"
    }

/* Methods used in the Udacity API */
    
    //Methods
    struct Methods {
        
        //Session
        static let Session = "session"        
        //Users
        static let Users = "users"

        
    }

/* URL parameters used in the API*/

    struct URLKeys {
        
        static let userID = "user_id"
        
    }
    
/* Body keys for requesting from the API */
    
    struct JSONBodyKeys {
        
        static let username = "username"
        static let password = "password"
        
    }
/* Response keys for understanding responses */
    
    // JSON Response Keys
    struct JSONResponseKeys {
        
        // Authorization
        static let SessionId = "id"
        static let Expiration  = "expiration"
        
        
        // Account
        static let Registered = "registered"
        static let Key = "key"
        
        // User
        static let lastName = "last_name"
        static let firstName = "first_name"
        static let websiteURL = "website_url"
        static let location = "location"
    }
}


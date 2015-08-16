//
//  ParseConstants.swift
//  On the Map
//
//  Created by Enrico Montana on 8/15/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

extension ParseClient {
    
    struct Constants {
        
        //Parse Application ID
        static let parseAppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        //REST API Key
        static let apiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //URLs
        static let BaseURL : String = "https://api.parse.com/1/classes/StudentLocation"

    }
    
    //Methods
    struct Methods {
        
        
    }
    // JSON Response Keys
    struct JSONResponseKeys {
        
        // Student Location
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        //static let ACL = "ACL"
        
        //Results
        static let studentLocationResults = "results"
        
    }

    
    
}
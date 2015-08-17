//
//  ParseStudentLocation.swift
//  On the Map
//
//  Created by Enrico Montana on 8/15/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation

/* Define the StudentLocation */
struct StudentLocation {
    
    var objectId = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude = 0.00
    var longitude = 0.00
    var createdAt = ""
    var updatedAt = ""
    //var ACL = ""

/* Create an init from NSDictionary */
    
    init(dictionary: [String : AnyObject]) {
        
        objectId = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as! Double
        createdAt = dictionary[ParseClient.JSONResponseKeys.createdAt] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.updatedAt] as! String
        //ACL = dictionary[ParseClient.JSONResponseKeys.ACL] as! String

    }
 
/* Easily make an array from API results */
    
    static func studentLocationFromResults (results: [[String : AnyObject]]) -> [StudentLocation] {
        var studentLocations = [StudentLocation]()
        
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }

}
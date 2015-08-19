//
//  ParseClient.swift
//  On the Map
//
//  Created by Enrico Montana on 8/15/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    
    /* Standardized JSON parsing function */
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if parsingError != nil {
            
            completionHandler(result: nil, error: parsingError)
            
        } else {
            
            completionHandler(result: parsedResult, error: nil)
            
        }
    }
    
    /* Allow for params when getting data of locations */
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
}
//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Enrico Montana on 8/15/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit


extension ParseClient {
    
    func refreshStudentLocations (completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        getStudentLocations() { (data,success,errorString) in
            if success {
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                
                appDelegate.studentLocations = data!
                completionHandler(success: true, errorString: nil)
                
            
            } else
            
            {
                completionHandler(success: false, errorString: "Could not refresh list")
            }
        
        }
    
    }
    
    
    func getStudentLocations (completionHandler: (data: [StudentLocation]?, success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Constants.BaseURL)!)
        request.addValue(ParseClient.Constants.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(data: nil, success: false, errorString: "broken")
            }
            //println("convert data to array of locations")
            //var parsingError: NSError? = nil
            //let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            
            let parsedResult = ParseClient.parseJSONWithCompletionHandler(data) { result, error in
                
                if error != nil {
                    
                    println("Parsing broke somehow")
                    
                } else {
                    
                    
                    if let loc = result.valueForKey(ParseClient.JSONResponseKeys.studentLocationResults) as? [[String : AnyObject]] {
                        
                        var studentLocations = StudentLocation.studentLocationFromResults(loc)
                        
                        completionHandler(data: studentLocations, success: true, errorString: nil)
                        
                    }
                }
            }
            
        }
        task.resume()
    }
}

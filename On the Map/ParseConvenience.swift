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
                completionHandler(success: false, errorString: errorString)
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
                
                completionHandler(data: nil, success: false, errorString: "Locations Request Broke")
            }
            
            let parsedResult = ParseClient.parseJSONWithCompletionHandler(data) { result, error in
                
                if error != nil {
                    
                    completionHandler(data: nil, success: false, errorString: "Parsing Broke")
                    
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
    
    func getStudentLocation(completionHandler: (success: Bool, data: String, errorString: String?) -> Void){
        
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let uniqueKey = appDelegate.udacityUserKey
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        var objectId = ""
        
        request.addValue(ParseClient.Constants.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil {
                
                completionHandler(success: false, data: objectId, errorString: "Could not connect to API")
                
            } else {
                
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let userLocation = parsedResult.valueForKey(ParseClient.JSONResponseKeys.studentLocationResults) as? [[String : AnyObject]] {
                    
                    var userLocations = StudentLocation.studentLocationFromResults(userLocation)
                    
                    if userLocations.count == 0 {
                        completionHandler(success: false, data: objectId, errorString: "User not found")
                    } else {
                        
                        objectId = userLocations[0].objectId
                        completionHandler(success: true, data: objectId, errorString: nil)
                        
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    func postStudentLocation(location: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void){
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let uniqueKey = appDelegate.udacityUserKey
        let fName = appDelegate.firstName
        let lName = appDelegate.lastName
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(fName)\", \"lastName\": \"\(lName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)

                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { data, response, error in
                    if error != nil {
                        completionHandler(success: false, errorString: "Save was unsuccessful")
                    }
                }
                task.resume()
        
        completionHandler(success: true, errorString: nil)
    
    }
    
    func putStudentLocation(objectId: String, location: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: (success: Bool, errorString: String?) -> Void){
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        let uniqueKey = appDelegate.udacityUserKey
        let fName = appDelegate.firstName
        let lName = appDelegate.lastName
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(objectId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        
        request.HTTPMethod = "PUT"
        request.addValue(ParseClient.Constants.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(fName)\", \"lastName\": \"\(lName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, errorString: "Update unsuccessful")
            } else {
                completionHandler(success: true, errorString: nil)
            }
        }
        task.resume()
    }
}

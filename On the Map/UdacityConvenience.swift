//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Convenient Resource Methods

extension UdacityClient {
    

    
    func login (username: String, password: String, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let urlString = Constants.BaseURL + Methods.Session
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if let error = downloadError {
                
                completionHandler(success: false, errorString: "Download error")
                
            } else {
                
                let newData = data .subdataWithRange(NSMakeRange(5, data.length - 5))
                
                var parsingError: NSError? = nil
                
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                println(parsedResult)
                
                if parsedResult["status"] == nil {
                    
                    self.accountKey = parsedResult.valueForKeyPath("account.key") as? String
                    self.accountRegistered = parsedResult.valueForKeyPath("account.registered") as? Bool
                    self.sessionID = parsedResult.valueForKeyPath("session.id") as? String
                    self.sessionExpiration = parsedResult.valueForKeyPath("session.expiration") as? String
                    
//                    println(self.accountKey)
//                    println(self.accountRegistered)
//                    println(self.sessionID)
//                    println(self.sessionExpiration)
                
                    completionHandler(success: true, errorString: nil)
                
                } else {
                
                    completionHandler(success: false, errorString: parsedResult["error"] as! String)
                
                }
//                
//                println(parsedResult)
//                println(parsedResult["status"])
                
            }
        }
        task.resume()
        
    }
    
}


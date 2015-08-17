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
                
                completionHandler(success: false, errorString: "Could not connect to login")
                
            } else {
                
                let newData = data .subdataWithRange(NSMakeRange(5, data.length - 5))
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if parsedResult["status"] == nil {
                    
                    self.accountKey = parsedResult.valueForKeyPath("account.key") as? String
                    self.accountRegistered = parsedResult.valueForKeyPath("account.registered") as? Bool
                    self.sessionID = parsedResult.valueForKeyPath("session.id") as? String
                    self.sessionExpiration = parsedResult.valueForKeyPath("session.expiration") as? String
                    
                    self.getPublicUserData(self.accountKey!) { (success, errorString) in
                        
                        if success {
                            completionHandler(success: true, errorString: nil)
                        } else {
                            completionHandler(success: false, errorString: "Could not get your public user data")
                        }
                    }
                    
                } else {
                    
                    completionHandler(success: false, errorString: "Login failed")
                    
                }
                
            }
        }
        task.resume()
        
    }
    func getPublicUserData (udacityUserId: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let urlString = Constants.BaseURL + Methods.Users + "/" + udacityUserId
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                
                completionHandler(success: false, errorString: "Could not get the user data")
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            
            if parsedResult["user"] == nil {
                
                completionHandler(success: false, errorString: "Could not grab public user data")
            
            } else {
                
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                
                appDelegate.udacityUserKey = parsedResult.valueForKeyPath("user." + UdacityClient.JSONResponseKeys.Key) as! String
                appDelegate.firstName = parsedResult.valueForKeyPath("user." + UdacityClient.JSONResponseKeys.firstName) as! String
                appDelegate.lastName = parsedResult.valueForKeyPath("user." + UdacityClient.JSONResponseKeys.lastName) as! String

                completionHandler(success: true, errorString: nil)

            }

            
        }
        task.resume()
    }
    
    func logout (completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Couldn't logout")
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    
    }
}


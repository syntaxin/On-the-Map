//
//  TableTabbedViewController.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit

class TableTabbedViewController: UIViewController, UITableViewDataSource {
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.studentLocations = appDelegate.studentLocations
        
        if self.studentLocations.count == 0 {
            
            ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) in
                
                if success {
                    self.studentLocations = appDelegate.studentLocations
                } else
                {
                    println(errorString)
                }
                
            }
            
        }
        
    }


    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuseIndentifier = "StudentLocation"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIndentifier) as? UITableViewCell
        var studentRow = self.studentLocations[indexPath.row]
        
        if (cell != nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIndentifier)
            cell?.textLabel?.text = studentRow.firstName + " " + studentRow.lastName
            cell?.detailTextLabel?.text = studentRow.mediaURL
        
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = studentLocations[indexPath.row].mediaURL
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }

    
}
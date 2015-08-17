//
//  TableTabbedViewController.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit

class TableTabbedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "StudentLocation"
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    var tableViewController = UITableViewController(style: .Plain)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarMenuItems()

/* Grab shared data */
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.studentLocations = appDelegate.studentLocations

/* Create the table view */
        
        var tableView = tableViewController.tableView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)

/* If the shared data is empty, attempt a refresh */
        
        if self.studentLocations.count == 0 {
            
            ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) in
                
                if success {
                    self.studentLocations = appDelegate.studentLocations
                } else
                {
                    var alert = UIAlertView(title: nil, message: errorString, delegate: self, cancelButtonTitle: "Try again")
                    alert.show()
                    return
                }
                
            }
            
        }
        
    }


/* Table view implementation - get cell count */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }

/* Table view implemenatation - add cells */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        var studentRow = self.studentLocations[indexPath.row]
        
        if (cell != nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.text = studentRow.firstName + " " + studentRow.lastName
            cell?.detailTextLabel?.text = studentRow.mediaURL
        
        }
        
        
        return cell!
    }
 
/* Open a browser to the link if a row is selected */
    
    func tableView(UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let url = studentLocations[indexPath.row].mediaURL
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }

/* Deliberately refresh the list view */
    
    func refreshClick (sender:UIButton!) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) in
            
            if success {
                self.studentLocations = appDelegate.studentLocations
                self.tableViewController.tableView.reloadData()
            } else {
                var alert = UIAlertView(title: nil, message: errorString, delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
   
        }

    }
    
/* Go to the add location view controller */
    
    func addLocationClick (sender:UIButton!) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddOrEditLocation") as! PostViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }

/* Logout of the app go back to login */
    
    func logout (sender:UIButton!) {
        
        UdacityClient.sharedInstance().logout() { (success, errorString) in
            
            if success {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                self.navigationController!.presentViewController(controller, animated: false, completion: nil)
                
            } else {
                
                var alert = UIAlertView(title: nil, message: errorString, delegate: self, cancelButtonTitle: "Could not logout")
                alert.show()
                return
            }
        }
    }
}
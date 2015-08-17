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
    var refreshControl = UIRefreshControl()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarMenuItems()
    
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.studentLocations = appDelegate.studentLocations
        
        var tableView = tableViewController.tableView
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self

        
        tableViewController.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: "refreshPull", forControlEvents: .ValueChanged)
        
        self.view.addSubview(tableView)

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
        
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        var studentRow = self.studentLocations[indexPath.row]
        
        if (cell != nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.text = studentRow.firstName + " " + studentRow.lastName
            cell?.detailTextLabel?.text = studentRow.mediaURL
        
        }
        
        
        return cell!
    }
    
    func tableView(UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        let url = studentLocations[indexPath.row].mediaURL
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func refreshClick (sender:UIButton!) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) in
            
            if success {
                self.studentLocations = appDelegate.studentLocations
                self.tableViewController.tableView.reloadData()
                
            } else {
                println("Refresh locations broke")
            }
   
        }

    }
    
    func refreshPull () {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) in
            
            if success {
                self.studentLocations = appDelegate.studentLocations
                self.tableViewController.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            } else {
                println("Refresh locations broke")
            }
            
        }
        
    }
    
    func addLocationClick (sender:UIButton!) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddOrEditLocation") as! PostViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }


    
}
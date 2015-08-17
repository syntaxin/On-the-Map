//
//  MapViewController.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocations: [StudentLocation] = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.addNavBarMenuItems()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        self.studentLocations = appDelegate.studentLocations
        
        if self.studentLocations.count == 0 {
            
                populateTheMap()

                } else {
                    println("Refresh locations broke")
                }

        }
    
    func annotateTheMap(){
        
        
        for item in self.studentLocations {
            let lat = CLLocationDegrees(item.latitude)
            let long = CLLocationDegrees(item.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = item.firstName
            let last = item.lastName
            let mediaURL = item.mediaURL
            let mapString = item.mapString
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last) from \(mapString)"
            annotation.subtitle = mediaURL
            
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotation(annotation)
            })
            
            
            
        }
        
    }
    
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation != nil {
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView?.canShowCallout = true
            pinView?.pinColor = .Red
            pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            
            return pinView
        }
        else {
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            return pinView
            
        }
    }
    
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let url = annotationView.annotation.subtitle
            UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
        }
    }
    
    func addNavBarMenuItems()
    {
        
        let buttonRefresh: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonRefresh.frame = CGRectMake(0, 0, 40, 40)
        buttonRefresh.setImage(UIImage(named:"listIcon"), forState: UIControlState.Normal)
        buttonRefresh.addTarget(self, action: "refreshClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonRefreshRight: UIBarButtonItem = UIBarButtonItem(customView: buttonRefresh)
        
        
        let buttonAddLocation: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonAddLocation.frame = CGRectMake(0, 0, 40, 40)
        buttonAddLocation.setImage(UIImage(named:"listIcon"), forState: UIControlState.Normal)
        buttonAddLocation.addTarget(self, action: "addLocationClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonAddLocationRight: UIBarButtonItem = UIBarButtonItem(customView: buttonAddLocation)
        
        let buttonLogout: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonLogout.frame = CGRectMake(0, 0, 40, 40)
        buttonLogout.setImage(UIImage(named:"listIcon"), forState: UIControlState.Normal)
        buttonLogout.addTarget(self, action: "buttonLogoutClick:", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonLogoutLeft: UIBarButtonItem = UIBarButtonItem(customView: buttonLogout)
        
        self.navigationItem.setRightBarButtonItems([buttonRefreshRight, buttonAddLocationRight], animated: true)
        self.navigationItem.setLeftBarButtonItems([buttonLogoutLeft], animated: true)
        
    }
    
    func refreshClick (sender:UIButton!) {
        //println("Clear the Map")
        
        let annotationsToRemove = mapView.annotations.filter { $0 !== self.mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        
        populateTheMap()
        

    }
    
    func addLocationClick (sender:UIButton!) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddOrEditLocation") as! PostViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func buttonLogoutClick (sender:UIButton!) {
        println("Let me logout")
    }
    
    func populateTheMap() {
    
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) in
            
            if success {
                self.studentLocations = appDelegate.studentLocations
                dispatch_async(dispatch_get_main_queue(), {
                    self.annotateTheMap()
                })
            } else {
                println("Refresh locations broke")
            }
            
        }

    }
}


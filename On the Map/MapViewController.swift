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
    
    var myFirstName: String!
    var myLastName: String!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

/* Add shared menu items */
        
        self.addNavBarMenuItems()

/* Grab shared data */
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        self.myFirstName = appDelegate.firstName
        self.myLastName = appDelegate.lastName

        
        self.studentLocations = appDelegate.studentLocations

/* Populate the map with pins */
        
        populateTheMap()

    }
    
/* Helper function to reuse just for annotations */
    
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
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotation(annotation)
            })

        }
        
    }
    
    
 /* Decide pin style based on whether it's the same user as who's logged in */
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation.title == "\(self.myFirstName) \(self.myLastName)" {
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView?.canShowCallout = true
            pinView?.pinColor = .Purple
            pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            
            return pinView
        }
        else {
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView?.canShowCallout = true
            pinView?.pinColor = .Red
            pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
            
            return pinView
        }
    }
    
/* Open a link in a browser when detail view is clicked */
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let url = annotationView.annotation.subtitle
            UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
        }
    }

/* Helper function to refresh data then annotate the map later */
    
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
                
                var alert = UIAlertView(title: nil, message: errorString, delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            
        }

    }
   
 /* Deliberate refresh of the map data */
    
    func refreshClick (sender:UIButton!) {

        let annotationsToRemove = mapView.annotations.filter { $0 !== self.mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        
        populateTheMap()

    }
 
/* Go the add/edit location viewController */
    
    func addLocationClick (sender:UIButton!) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddOrEditLocation") as! PostViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }

/* Logout and go back to signin */
    
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


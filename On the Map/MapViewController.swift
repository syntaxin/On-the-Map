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
    var selectedView: MKAnnotationView?
    var tapGesture: UITapGestureRecognizer!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    //        ParseClient.sharedInstance().getStudentLocations(){ (data, success, errorString) in
    //            if success {
    //                appDelegate.studentLocations = data!
    //                self.studentLocations = appDelegate.studentLocations
    //
    //                dump(appDelegate.studentLocations)
    //
    //                dispatch_async(dispatch_get_main_queue(), {
    //                    self.annotateTheMap()
    //                })
    //
    //            } else {
    //
    //                println("I never got an array")
    //
    //            }
    //       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: "calloutTapped:")
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        self.studentLocations = appDelegate.studentLocations
        
        println(self.studentLocations.count)
        
        if self.studentLocations.count == 0 {
            
            ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) in
                
                if success {
                    self.studentLocations = appDelegate.studentLocations
                    println(self.studentLocations.count)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.annotateTheMap()
                    })
                } else
                {
                    self.studentLocations = appDelegate.studentLocations
                    println(self.studentLocations.count)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.annotateTheMap()
                    })
                }
                
            }
            
            
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
    
}


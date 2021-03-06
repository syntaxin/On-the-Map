//
//  PostViewController.swift
//  On the Map
//
//  Created by Enrico Montana on 8/14/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocationButton: UIButton!
    
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var locationTitle: String!
    var lat: Double!
    var long: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Prepare the UI */
        
        self.tabBarController?.tabBar.hidden = true
        self.addLocationButton.hidden = true
        self.inputTextField.placeholder = "Find your location!"
        mapView.delegate = self
        
    }
    /* Check to see if the location can be found and if so, render and animate the map so the user knows something is happening */
    
    @IBAction func findLocation(sender: AnyObject) {
        ActivityProgress.shared.showProgressView(view)
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = inputTextField.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                dispatch_async(dispatch_get_main_queue(),{
                    ActivityProgress.shared.hideProgressView()
                    var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                    alert.show()
                    return
                })
            } else {
                ActivityProgress.shared.hideProgressView()
                let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
                self.mapView.removeAnnotations( annotationsToRemove )
                
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.inputTextField.text
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.centerCoordinate = self.pointAnnotation.coordinate
                self.mapView.addAnnotation(self.pinAnnotationView.annotation)
                
                self.locationTitle = self.inputTextField.text
                self.lat = self.pointAnnotation.coordinate.latitude
                self.long =  self.pointAnnotation.coordinate.longitude
                
                let mapCoordinate = self.pointAnnotation.coordinate
                
                var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCoordinate, fromEyeCoordinate: mapCoordinate, eyeAltitude: 100000)
                self.mapView.setCamera(mapCamera, animated: true)
                
                
                self.inputTextField.text = nil
                self.inputTextField.placeholder = "Share a link!"
                self.findLocationButton.hidden = true
                self.addLocationButton.hidden = false
                
                
                return
            }
        }
    }
    
    /* Add the selected location and check to make sure a link is included.  If the user exists, choose to update.  If they do not, add it to the datastore */
    
    @IBAction func addLocation(sender: AnyObject) {
        
        if self.inputTextField.text.isEmpty {
            var alert = UIAlertView(title: nil, message: "Enter a link to share", delegate: self, cancelButtonTitle: "Try again")
            alert.show()
            return
        }
        ActivityProgress.shared.showProgressView(view)
        ParseClient.sharedInstance().getStudentLocation(){ success, data, errorString in
            if success {
                
                
                ParseClient.sharedInstance().putStudentLocation(data,location:self.locationTitle, mediaURL: self.inputTextField.text, latitude: self.lat, longitude: self.long){ success, errorString in
                    
                    if success {
                        dispatch_async(dispatch_get_main_queue(), {
                            ActivityProgress.shared.hideProgressView()
                            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarControllerForView") as! UITabBarController
                            self.presentViewController(controller, animated: true, completion: nil)
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(),{
                            ActivityProgress.shared.hideProgressView()
                            var alert = UIAlertView(title: nil, message: errorString, delegate: self, cancelButtonTitle: "Try again")
                            alert.show()
                            return
                        })
                    }
                }
                
            } else {
                
                ParseClient.sharedInstance().postStudentLocation(self.locationTitle, mediaURL: self.inputTextField.text, latitude: self.lat, longitude: self.long){ success, errorString in
                    
                    if success {
                        dispatch_async(dispatch_get_main_queue(), {
                            ActivityProgress.shared.hideProgressView()
                            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarControllerForView") as! UITabBarController
                            self.presentViewController(controller, animated: true, completion: nil)
                        })
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(),{
                            ActivityProgress.shared.hideProgressView()
                            var alert = UIAlertView(title: nil, message: errorString, delegate: self, cancelButtonTitle: "Try again")
                            alert.show()
                            return
                        })
                    }
                }
            }
        }
        
    }
    
    /* Color the pin the same as personal pins on the map view (purple) */
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation != nil {
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = false
            pinView?.pinColor = .Purple
            
            return pinView
        }
        else {
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            return pinView
            
        }
    }
    
    
}
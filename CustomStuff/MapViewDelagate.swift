//
//  MapViewDelagate.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/23/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import Foundation

import MapKit

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        // Added the ability to create annotations of custom type User, just like Artwork above
        if let annotation = annotation as? User {
            
            let identifier1 = "userPin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier1) as? MKPinAnnotationView {
                
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                
                print("Making new pin")
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier1)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y:5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                
                view.leftCalloutAccessoryView = UIImageView(image: UIImage(named:"no-profile-pic"))
                view.leftCalloutAccessoryView!.frame = CGRectMake(0.0, 0.0, 55.0, 55.0)
                
                // Set a custom color for the user pin
                view.pinTintColor = annotation.pinColor()
            }
            return view

        }
        
        return nil
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            performSegueWithIdentifier("showUserDetails", sender: view)
        }
    }
    
    
    // Implement delegate methods for CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error finding location: \(error.localizedDescription)")

    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("User Location Was updated")
        
        let location = locations.last
        
        // This will give us a
        let regionRadius: CLLocationDistance = 2000
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegionMakeWithDistance(center, regionRadius, regionRadius)
        
        userMap.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
    
    }
    
    
    // Get alllll the information needed from the Annotation of the pin (the user)
    //Right now I am using Artwork, AND User but eventually will be using only the User class of type MKAnnotation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let identifier = segue.identifier
        
        if identifier == "showUserDetails" {
            
            if let vc = segue.destinationViewController as? UserViewController {
                
                let thePin = sender as? MKPinAnnotationView
                
                if thePin != nil {
                    
                    if let userProfile = thePin?.annotation as? User{
                        
                        vc.userDetails = userProfile
                        
                    }
                }
            }
        }
    }
    
    
}

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
    
    /*
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("User Location Was updated " + "\(++tempCountLocationUpdates)")
        
        let location = locations.last
        
        if(regionSet == false){
        
            // This will give us a region, and set it
            let regionRadius: CLLocationDistance = 2000
            
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            
            let region = MKCoordinateRegionMakeWithDistance(center, regionRadius, regionRadius)
            
            userMap.setRegion(region, animated: true)
            
            regionSet = true
        }
        
        // locationManager.stopUpdatingLocation()
        
        // Send off a request to update the user's most current location, and to get all closest users around
        // Ony send when user has moved more than .25 miles from first location found
        // This ideally will only show users who are currently online
    }
    */
    
    // Get alllll the information needed from the Annotation of the pin (the user)
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

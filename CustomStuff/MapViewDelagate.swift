//
//  MapViewDelagate.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/23/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import Foundation

import MapKit

extension MapViewController: MKMapViewDelegate {
    
    // 1
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Artwork {
            
            let identifier = "artworkPin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
             
                // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            }
            else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y:5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                view.leftCalloutAccessoryView = UIButton(type: .ContactAdd) as UIView
                
            }
            return view
        }
        
        return nil
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            performSegueWithIdentifier("showArtworkDetail", sender: view)
        }
    }
    
    // Get alllll the information needed from the Annotation of the pin (the user)
    //Right now I am using Artwork, but eventually will be using the User class of type MKAnnotation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let identifier = segue.identifier
        
        if identifier == "showArtworkDetail" {
            
            if let vc = segue.destinationViewController as? UserViewController {
                
                let thePin = sender as? MKPinAnnotationView
                
                if thePin != nil {
                    
                    let artwork = thePin?.annotation as? Artwork
                    
                    vc.pieceOfArt = artwork
                }
            }
        }
    }
    
    
    
    
}

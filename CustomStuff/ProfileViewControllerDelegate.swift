//
//  ProfileViewControllerDelegate.swift
//  Weavr
//
//  Created by Joshua Peeling on 6/4/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import Foundation
import MapKit

extension ProfileViewController : CLLocationManagerDelegate {
    
    
    // Implement delegate methods for CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error finding location: \(error.localizedDescription)")
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        tempCountLocationUpdates += 1
        print("User Location Was updated " + "\(tempCountLocationUpdates)")
        
        let location = locations.last
        
        // Store most recent location in NSUserDefaults
        prefs.setValue(location!.coordinate.latitude, forKey: "currentLatitude")
        prefs.setValue(location!.coordinate.longitude, forKey: "currentLongitude")
        
        // locationManager.stopUpdatingLocation()
        
        // Send off a request to update the user's most current location, and to get all closest users around
        // Ony send when user has moved more than .25 miles from first location found
        // This ideally will only show users who are currently online
    }
    
}

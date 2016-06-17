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
        print("Persistent value for latitude: " + "\(DataControl.getInstance().currentLatitude)")
        
        // First Location that is collected
        // Need to account for conditions on when to call this if block
        if(persistentLocation == nil || DataControl.getInstance().needLocationUpdate == true){
            
            //Only needed when app is already running and new user just logged in
            DataControl.getInstance().needLocationUpdate = false
            
            print("Just got first Location from user this session")
            persistentLocation = location
            
            // Store most recent location in DataControl
            // Do this so that MapViewController can access most persistent location to find other users
            DataControl.getInstance().currentLatitude = location!.coordinate.latitude
            DataControl.getInstance().currentLongitude = location!.coordinate.longitude
            DataControl.getInstance().mapRegionSet = false
            
            updateUserLocation()
        }
        else{
            
        // Check persistent location against new one
        // If new one is > 328 ft away, update with new location
            
            let distance = persistentLocation!.distanceFromLocation(location!)
            print("Distance from last: " + "\(distance)")
            
            // Do Api Call right here
            if(distance > 20){
                
                // Store most recent location in DataControl
                // Do this so that MapViewController can access most persistent location to find other users
                DataControl.getInstance().currentLatitude = location!.coordinate.latitude
                DataControl.getInstance().currentLongitude = location!.coordinate.longitude
                DataControl.getInstance().mapRegionSet = false

                
                // Update the persistent location to the new one
                persistentLocation = location
                
                updateUserLocation()
            }
            
        
        }
        
        // locationManager.stopUpdatingLocation()
        
        // Send off a request to update the user's most current location, and to get all closest users around
        // Ony send when user has moved more than .25 miles from first location found
        // This ideally will only show users who are currently online
    }
    
    func updateUserLocation(){
        
        // Check NSUserDefaults for a "currentToken" to access the server with...
        // Use below line for testing, if you need to remove the current token
        //prefs.removeObjectForKey("currentToken")
        
        if DataControl.getInstance().tokenExists(){
            
            let currentToken = DataControl.getInstance().getToken()
            let urlString = "http://192.81.216.130:8000/api/updateUserLocation"
            
            let storedID = "&_id=" + DataControl.getInstance().getID()
            let latitude = "&latitude=" + String(DataControl.getInstance().currentLatitude)
            let longitude = "&longitude=" + String(DataControl.getInstance().currentLongitude)
            
            print(latitude)
            print(longitude)
            
            var message = "foo"
            
            // Get JSON from server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
            let url = NSURL(string: urlString)
            let request  = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            let bodyData = "token=" + currentToken + storedID + latitude + longitude
            
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            // Make HTTP request
            session.dataTaskWithRequest(request, completionHandler: { data, response, error in
                
                if (data != nil) {
                    
                    // Parse result JSON
                    let json = JSON(data: data!)
                    print("JSON response:" +  "\(json)")
                    
                    let success = json["success"].stringValue
                    print("\("User Location Updated: " + success)")
                    
                    // The current token we have is already valid and not exired! YAY!
                    // We have complete access to the User Information
                    if(success != "false") {
                        
                        message = json["message"].stringValue
                        print("\(message)")
                        
                        // we just know now that the user is still authenticated
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            // Set the user's location Name field
                            print("Setting the new Location name we got: " + json["userLocationName"].stringValue)
                            self.locationLabel.text = "At: " + json["userLocationName"].stringValue
                            
                        }
                    }
                        
                        // The current token we have is NOT VALID, most likely expired...
                    else {
                        message = json["message"].stringValue
                        print("\(message)")
                        
                        // Remove the cached token and user ID, as they are expired
                        DataControl.getInstance().clearUserPersistingData() 
                        
                        // Send off a thread to get user off of screen...send them to the ProfileViewController for now...
                        // Profile view controller will read that there are no keys in the prefs.
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.tabBarController!.selectedIndex = 0
                        }
                        
                    }
                    
                }
                else {
                    print("Data is nil")
                }
                
                if(error != nil) {
                    print("\(error)")
                }
                
            }).resume()
        }
            
            // Just redirect User Automatically to the login screen if the token does not exist in NSUserDefaults
        else {
            
            self.tabBarController!.selectedIndex = 0
        }
        
        
    }
    
}

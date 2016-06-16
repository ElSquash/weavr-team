//
//  MapViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/22/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var userMap: MKMapView!
    
    let regionRadius: CLLocationDistance = 2000
    var users = [User]()
    var regionSet = false
    var tempCountLocationUpdates = 0
    var prefs = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Check NSUserDefaults for a "currentToken" to access the server with...
        // Use below line for testing, if you need to remove the current token
        //prefs.removeObjectForKey("currentToken")
        
        if let currentToken = prefs.stringForKey("currentToken"){
            
            let storedID = prefs.stringForKey("_id")
            print("My Current user ID is: " + storedID!)
            let urlString = "http://192.81.216.130:8000/api/checkTokenExpired"
            var message = "foo"
            
            
            
            // Get JSON from server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config, delegate: nil, delegateQueue: nil)
            let url = NSURL(string: urlString)
            let request  = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            let bodyData = "token=" + currentToken + "&_id=" + storedID!
            
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
            
            // Make HTTP request
            session.dataTaskWithRequest(request, completionHandler: { data, response, error in
                
                if (data != nil) {
                    
                    // Parse result JSON
                    let json = JSON(data: data!)
                    print(json)
                    let success = json["success"].stringValue
                    print("\("Token valid: " + success)")
                    
                    // The current token we have is already valid and not exired! YAY!
                    // We have complete access to the User Information
                    if(success != "") {
                        
                        print("Token still valid, keep the user logged in :)")
                        
                        // we just know now that the user is still authenticated
                        dispatch_async(dispatch_get_main_queue()) {
                            
                        }
                    }
                        
                        // The current token we have is NOT VALID, most likely expired...
                    else {
                        message = json["message"].stringValue
                        print("\(message)")
                        
                        // Remove the cached token and user ID, as they are expired
                        self.prefs.removeObjectForKey("currentToken")
                        self.prefs.removeObjectForKey("_id")
                        self.prefs.removeObjectForKey("currentLatitude")
                        self.prefs.removeObjectForKey("currentLongitude")

                        
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userMap.delegate = self
        
        userMap.showsUserLocation = true
        
        // Code to set the region, if the region has not been set yet
        print("Region Set already: " + "\(regionSet)")
        if(regionSet == false){
            
            print("Setting region for the first time")
            
            // This will give us a region, and set it
            // -------------------------------------------------------------------------------
            // MAKE SURE THIS IS WORKING
            let regionRadius: CLLocationDistance = 2000
            let latitude = prefs.valueForKey("currentLatitude") as! CLLocationDegrees
            let longitude = prefs.valueForKey("currentLongitude") as! CLLocationDegrees
            print("Latitude: " + "\(latitude)")
            print("Longitude: " + "\(longitude)")

            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegionMakeWithDistance(center, regionRadius, regionRadius)
            userMap.setRegion(region, animated: true)
            
            regionSet = true
            // -------------------------------------------------------------------------------
        }
        
        // Load fake JSON data
        // This is where the sample file of users is currently parsed, and the User annotations are created and added to an array
        loadInitialUsers()
        
        // Need to add an API call to get all currently active users who are within 1 mile
        loadActiveCloseUsers()
        
        userMap.addAnnotations(users)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadActiveCloseUsers(){
        
        
    }
    
    
    // Load initial user profile samples from local json file userProfiles, modeled after the properties of the ProfileViewController
    func loadInitialUsers() {
        
        let fileName = NSBundle.mainBundle().pathForResource("userProfiles", ofType:"json")
        var data: NSData!
        var readError: ErrorType?
        var jsonObject: AnyObject!
        
        do {
            data = try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
            
        } catch {
            readError = error
            print("Could not get raw data from file: \(readError)")
        }
        
        var jsonError: ErrorType?
        do {
            
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue:0))
            
        } catch {
            jsonError = error
            print("Could not turn data into JSON object: \(jsonError)")
        }
        
        if let jsonObject = jsonObject as? [String : AnyObject] where jsonError == nil,
        
            let jsonUserData = JSONValue.fromObject(jsonObject)?["users"]?.array {
                
                // I have an array of JSON objects, each on is a user.
                for userJSON in jsonUserData {
                    
                    if let userJSON = userJSON.object,
                        user = User.fromJSON(userJSON) {
                            users.append(user)
                            print("\(user.topicOne)")
                        }
                }
        }
    }

    
    
    @IBAction func onBurger() {
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }


}

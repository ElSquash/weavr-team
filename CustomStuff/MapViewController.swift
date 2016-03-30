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
    
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 2000
    var artworks = [Artwork]()
    var users = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userMap.delegate = self
        locationManager.delegate = self
        
        // Set up the preliminary settings for user location
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        print("Got here")
        locationManager.startUpdatingLocation()
        
        userMap.showsUserLocation = true
        
        // Load fake JSON data
        
        loadInitialData()
        userMap.addAnnotations(artworks)
        
        // This is where the sample file of users is parsed, and the User annotations are created and added to an array
        loadInitialUsers()
        userMap.addAnnotations(users)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadInitialData(){
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json")
        var data: NSData!
        var readError: ErrorType?
        var jsonObject: AnyObject!
        do {
            
            data =  try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
    
        } catch {
            readError = error
            print("could not get data from file: \(readError)")
        }
        
        // 2
        var jsonError: ErrorType?
        do {
            
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue:0))
            
        } catch {
            jsonError = error
            print("Could not turn data into JSON object: \(jsonError)")
        }
        
        // 3
        if let jsonObject = jsonObject as? [String: AnyObject] where jsonError == nil,
        
        // 4
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
                
                for artworkJSON in jsonData {
                    
                    if let artworkJSON = artworkJSON.array,
                    
                    // 5
                        artwork = Artwork.fromJSON(artworkJSON) {
                            artworks.append(artwork)
                    }
                }
        }
        
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

//
//  ProfileViewController.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/10/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import UIKit
import MapKit

class ProfileViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var metStarsBlocked: UISegmentedControl!
    
    @IBOutlet weak var profile_pic: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topicOneLabel: UILabel!
    
    @IBOutlet weak var topicTwoLabel: UILabel!
    
    @IBOutlet weak var topicThreeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var leavingLabel: UILabel!
    
    @IBOutlet weak var userWords: UITextView!
    
    var userDetails : User?
    
    // Properties for CLLocationManager in ProfileViewControllerDelegate
    var locationManager = CLLocationManager()
    var tempCountLocationUpdates = 0
    var persistentLocation : CLLocation?
    let prefs = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Check NSUserDefaults for a "currentToken" to access the server with...
        // Use below line for testing, if you need to remove the current token
        
        //prefs.removeObjectForKey("currentToken")
        
        if let currentToken = prefs.stringForKey("currentToken"){
            
            let storedID = prefs.stringForKey("_id")
            print("My Current user ID is: " + storedID!)
            let urlString = "http://192.81.216.130:8000/api/getSingleUserInfo"
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
                    let userName = json["userName"].stringValue
                    print("\(userName)")
                    
                    // The current token we have is already valid and not exired! YAY!
                    // We have complete access to the User Information
                    if(userName != "") {
                        
                        print("Token still valid, populate user data :)")
                        
                        // Send off thread to get ALL current values of user from the API on the server...and set them in the view controller
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            // Set up the preliminary settings for user location
                            self.locationManager.delegate = self
                            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                            
                            self.locationManager.requestWhenInUseAuthorization()
                            self.locationManager.startUpdatingLocation()
                            
                            // Display all information needed from the API call
                            self.name.text = json["firstName"].stringValue + " " + json["lastName"].stringValue
                            
                            self.metStarsBlocked.setTitle("Met " + json["metNumber"].stringValue, forSegmentAtIndex: 0)
                            self.metStarsBlocked.setTitle("Stars " + json["starsNumber"].stringValue, forSegmentAtIndex: 1)
                            self.metStarsBlocked.setTitle("Blocked " + json["blockedNumber"].stringValue, forSegmentAtIndex: 2)
                            
                            self.topicOneLabel.text = json["topicOne"].stringValue
                            self.topicTwoLabel.text = json["topicTwo"].stringValue
                            self.topicThreeLabel.text = json["topicThree"].stringValue
                            
                            // Implement magic way of getting their location name from coordinates?
                            print("Location received from server: " + "\(json["locationName"].stringValue)")
                            self.locationLabel.text = "At: " + json["locationName"].stringValue

                            self.leavingLabel.text = "Until: " + json["leavingAt"].stringValue
                            
                            self.userWords.text = json["userWords"].stringValue
                            
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

                        
                        // Stop getting location, if the user is going to be logged out
                        self.locationManager.stopUpdatingLocation()
                        
                        // Send off a thread to get user off of screen...because they do not have a valid token.
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.performSegueWithIdentifier("showLoginSegue", sender: self)
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
            
            // Stop getting location, if the user is going to be logged out, because they don't have a token stored
            print("Stop Updating user location")
            self.locationManager.stopUpdatingLocation()
            
            self.performSegueWithIdentifier("showLoginSegue", sender: self)
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentSize.height = 1000
        
    }
    
    override func viewDidLayoutSubviews() {
        profile_pic.layer.borderWidth = 1
        profile_pic.layer.masksToBounds = false
        profile_pic.layer.borderColor = UIColor.whiteColor().CGColor
        profile_pic.layer.cornerRadius = profile_pic.frame.width/2
        profile_pic.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let identifier = "editProfileSegue"
        
        // User wants to go to Edit Profile page, so set up all the current data so it's there when they go
        if let vc = segue.destinationViewController as? UINavigationController {
            
            if segue.identifier == identifier {
                
                if let editProfileVC = vc.topViewController as? EditProfileViewController {

                    let editingText = self.userWords.text
                    let editingTopicOne = self.topicOneLabel.text
                    let editingTopicTwo = self.topicTwoLabel.text
                    let editingTopicThree = self.topicThreeLabel.text
                    
                    editProfileVC.previousUserInfo["userWords"] = editingText
                    editProfileVC.previousUserInfo["topicOne"] = editingTopicOne
                    editProfileVC.previousUserInfo["topicTwo"] = editingTopicTwo
                    editProfileVC.previousUserInfo["topicThree"] = editingTopicThree
                }
            }
        }
    }
    
    // Handle anything that needs to be done in the Profile page here, after updating the user info on the EditProfilePage
    @IBAction func unwindToProfileViewController(sender: UIStoryboardSegue) {
        
        print("Got here")
        if let _ = sender.sourceViewController as? EditProfileViewController {
            
            //print(sourceVC.updatedUserInfo!)
        }
        
    }
    
    
    @IBAction func onBurger() {
        
        (tabBarController as! TabBarController).sidebar.showInViewController(self, animated: true)
    }


}

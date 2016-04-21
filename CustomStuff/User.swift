//
//  User.swift
//  Weavr
//
//  Created by Joshua Peeling on 3/24/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import Foundation

import MapKit

class User: NSObject, MKAnnotation {
    let userName: String
    let firstName: String
    let lastName: String
    let metNumber: String
    let starsNumber: String
    let blockedNumber: String
    let profile_pic: UIImage
    let topicOne: String
    let topicTwo: String
    let topicThree: String
    let locationName: String
    let leavingAt: String
    let userWords: String
    let coordinate: CLLocationCoordinate2D
    
    init(userName: String, firstName: String, lastName: String, metNumber: String, starsNumber: String, blockedNumber: String, topicOne: String, topicTwo: String, topicThree: String, profile_pic: UIImage, locationName: String, leavingAt: String, userWords: String, coordinate: CLLocationCoordinate2D) {

        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.metNumber = metNumber
        self.starsNumber = starsNumber
        self.blockedNumber = blockedNumber
        self.topicOne = topicOne
        self.topicTwo = topicTwo
        self.topicThree = topicThree
        self.profile_pic = profile_pic
        self.locationName = locationName
        self.leavingAt = leavingAt
        self.userWords = userWords
        self.coordinate = coordinate
        
        super.init()
    }
    
    //This takes a dictonary of Json values (aka a User JSON object) and extracts all the required values
    class func fromJSON(json: [String: JSONValue]) -> User? {
        
        var tempUserName: String
        var tempMetNumber: Int
        var tempStarsNumber: Int
        var tempBlockedNumber: Int
        var tempTopicOne: String
        var tempTopicTwo: String
        var tempTopicThree: String
        var tempLocName: String
        var tempLeavingAt: String
        var tempUserWords: String
        var tempLat: Double
        var tempLong: Double
        
        //get User Name from JSON user object
        tempUserName = json["userName"]!.string!
        
        
        //get Met Number from JSON user Object
        tempMetNumber = json["metNumber"]!.integer!
            
        
        
        //get Stars Number from JSON user Object
        tempStarsNumber = json["starsNumber"]!.integer!
        
        
        //get Blocked Number from JSON user Object
        tempBlockedNumber = json["blockedNumber"]!.integer!
        
        
        //get Topic One from JSON user Object
        tempTopicOne = json["topicOne"]!.string!
        
        
        //get Topic Two from JSON user Object
        tempTopicTwo = json["topicTwo"]!.string!
        
        
        //get Topic Three from JSON user Object
        tempTopicThree = json["topicThree"]!.string!
        
        
        //get Location Name from JSON user Object
        tempLocName = json["locationName"]!.string!
        
        
        //get Leaving Time from JSON user Object
        tempLeavingAt = json["leavingAt"]!.string!
        
        //get User Words from JSON user Object
        tempUserWords = json["userWords"]!.string!
        
        
        //get Latitude from JSON user Object
        tempLat = (json["latitude"]!.string! as NSString).doubleValue
        
        //get Longitude from JSON user Object
        tempLong = (json["longitude"]!.string! as NSString).doubleValue
        
        
        return User(userName: tempUserName, firstName: "testFirst", lastName: "testLast", metNumber: String(tempMetNumber),starsNumber: String(tempStarsNumber), blockedNumber: String(tempBlockedNumber), topicOne: tempTopicOne, topicTwo: tempTopicTwo, topicThree: tempTopicThree, profile_pic: UIImage(named:"no-profile-pic")!, locationName: tempLocName, leavingAt: tempLeavingAt, userWords: tempUserWords, coordinate: CLLocationCoordinate2D(latitude: tempLat, longitude: tempLong))
        
        
    }
    
    //This is to compensate for the MKAnnotation title and subtitle properties needed in order to show a callout for a pin
    
    var title: String? {
        
        return userName
    }
    

    var subtitle: String? {
        return locationName
    }
    
    
    
    // set a custom pin color
    func pinColor() -> UIColor  {
        
        return UIColor.purpleColor()
        
    }
}
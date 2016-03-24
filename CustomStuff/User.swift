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
    let metNumber: String
    let starsNumber: String
    let blockedNumber: String
    let profile_pic: UIImage
    let locationName: String
    let leavingIn: String
    let userWords: String
    let coordinate: CLLocationCoordinate2D
    
    init(userName: String, metNumber: String, starsNumber: String, blockedNumber: String, profile_pic: UIImage, locationName: String, leavingIn: String, userWords: String, coordinate: CLLocationCoordinate2D) {

        self.userName = userName
        self.metNumber = metNumber
        self.starsNumber = starsNumber
        self.blockedNumber = blockedNumber
        self.profile_pic = profile_pic
        self.locationName = locationName
        self.leavingIn = leavingIn
        self.userWords = userWords
        self.coordinate = coordinate
        
        super.init()
    }
    
    /*
    class func fromJSON(json: [JSONValue]) -> User? {
        
        // 1
        var title: String
        
        if let titleOrNil = json[16].string {
            title = titleOrNil
        }
        else {
            
            title = ""
        }
        
        let locationName = json[12].string
        let discipline = json[15].string
        
        // 2
        let latitude = (json[18].string! as NSString).doubleValue
        let longitude = (json[19].string! as NSString).doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3
        return User(
        
    }
    */
    
    var subtitle: String? {
        return locationName
    }
}
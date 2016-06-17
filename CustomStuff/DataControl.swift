//
//  DataControl.swift
//  Weavr
//
//  Created by Joshua Peeling on 6/16/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import Foundation

class DataControl {
    
    static var instance : DataControl?
    
    // Keys for userDefaults
    // Holds data that must be carried accross instances of the app
    let TOKEN = "currentToken"
    let ID = "_id"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // Data that can be deleted accross instances of the app
    var needLocationUpdate = false
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    var mapRegionSet = false
    
    
    private init(){
        
    }
    
    static func getInstance()-> DataControl {
        
        if(instance == nil){
            
            instance = DataControl()
        }
        
        return instance!
    }
    
    func tokenExists() -> Bool{
        
        if userDefaults.stringForKey(TOKEN) != nil{
            
            return true
        }
        
        return false
    }
    
    func getToken() -> String {
        
        return userDefaults.stringForKey(TOKEN)!
    }
    
    func getID() -> String {
        
        return userDefaults.stringForKey(ID)!
    }
    
    
    func setUserPersistingData(token token: String, _id: String){
        
        userDefaults.setObject(token, forKey:TOKEN)
        userDefaults.setObject(_id, forKey:ID)
    }
    
    func clearUserPersistingData(){
        
        userDefaults.removeObjectForKey(TOKEN)
        userDefaults.removeObjectForKey(ID)
    }
    
    
    
}

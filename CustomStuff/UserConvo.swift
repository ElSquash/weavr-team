//
//  UserConvo.swift
//  Weavr
//
//  Created by Joshua Peeling on 4/14/16.
//  Copyright © 2016 Evan Dekhayser. All rights reserved.
//

import Foundation

class UserConvo {

    let userName : String
    let lastMessage : String
    let lastSent : String
    let userPic : String


    init (userName: String, userPic: String,lastMessage: String, lastSent: String) {

        self.userName = userName
        self.userPic = userPic
        self.lastMessage = lastMessage
        self.lastSent = lastSent
        
    }

}
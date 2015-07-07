//
//  Users.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Users {

    var DisplayName : String!
    var Email : String!
    var UserLogin : String!
    var Title : String!
    var Role : String!
    
    
    init(data : NSDictionary){

        self.DisplayName = Utils.getStringFromJSON(data, key: "Display Name")
        self.Email = Utils.getStringFromJSON(data, key: "Email")
        self.UserLogin = Utils.getStringFromJSON(data, key: "User Login")
        self.Title = Utils.getStringFromJSON(data, key: "Title")
        self.Role = Utils.getStringFromJSON(data, key: "Role")
        
    }
}
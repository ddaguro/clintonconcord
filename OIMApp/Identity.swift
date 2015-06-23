//
//  Identity.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Identity {
    
    //var Title :  String!
    //var Location : String!
    //var Url : String!
    
    var Email : String!
    var UserLogin : String!
    var FirstName : String!
    var LastName : String!
    var FullName : String!
    var Title : String!
    var Role : String!
    var UsrCreate : String!
    
    
    init(data : NSDictionary){
        
        //self.Title = Utils.getStringFromJSON(data, key: "title")
        //self.Location = Utils.getStringFromJSON(data, key: "location")
        //self.Url = Utils.getStringFromJSON(data, key: "siteurl")
        
        
        self.Email = Utils.getStringFromJSON(data, key: "Email")
        self.UserLogin = Utils.getStringFromJSON(data, key: "User Login")
        self.FirstName = Utils.getStringFromJSON(data, key: "First Name")
        self.LastName = Utils.getStringFromJSON(data, key: "Last Name")
        self.FullName = Utils.getStringFromJSON(data, key: "Full Name")
        self.Title = Utils.getStringFromJSON(data, key: "Title")
        self.Role = Utils.getStringFromJSON(data, key: "Role")
        self.UsrCreate = Utils.getStringFromJSON(data, key: "usr_create")
        
        
    }
}
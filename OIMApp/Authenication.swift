//
//  Authenication.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/19/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Authenication {
    
    var Username : String!
    var Password : String!
    var isAuthenicated : String!
    
    
    init(data : NSDictionary){
        
        self.Username = Utils.getStringFromJSON(data, key: "Username")
        self.Password = Utils.getStringFromJSON(data, key: "Password")
        self.isAuthenicated = Utils.getStringFromJSON(data, key: "isAuthenicated")
        
    }
}
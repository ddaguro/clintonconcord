//
//  Roles.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Roles {
    
    var description : String!
    var category : String!
    var requestID : String!
    var assignedOn : String!
    var membershipType : String!
    var roleKey : String!
    var roleName : String!
    
    
    init(data : NSDictionary){
        
        self.description = Utils.getStringFromJSON(data, key: "description")
        self.category = Utils.getStringFromJSON(data, key: "category")
        self.requestID = Utils.getStringFromJSON(data, key: "requestID")
        self.assignedOn = Utils.getStringFromJSON(data, key: "assignedOn")
        self.membershipType = Utils.getStringFromJSON(data, key: "membershipType")
        self.roleKey = Utils.getStringFromJSON(data, key: "roleKey")
        self.roleName = Utils.getStringFromJSON(data, key: "roleName")
        
        
        /*
        description: "Provides User-level access in the Learning Management System"
        category: "Default"
        requestID: "TBD ReqId"
        assignedOn: "Thu Apr 24 16:03:57 CDT 2014"
        membershipType: "TBD membershipType"
        roleKey: 128
        roleName: "Learning Management User"
        */
    }
}

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
    var roleKey : Int!
    var roleName : String!
    var catalogId : String!
    
    
    init(data : NSDictionary){
        
        self.description = Utils.getStringFromJSON(data, key: "description")
        self.category = Utils.getStringFromJSON(data, key: "category")
        self.requestID = Utils.getStringFromJSON(data, key: "requestID")
        self.assignedOn = Utils.getStringFromJSON(data, key: "assignedOn")
        self.membershipType = Utils.getStringFromJSON(data, key: "membershipType")
        self.roleKey = data["roleKey"] as! Int
        self.roleName = Utils.getStringFromJSON(data, key: "roleName")
        self.catalogId = Utils.getStringFromJSON(data, key: "catalogId")
        
        
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

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

class RoleItem {
    
    var roleDisplayName : String!
    var roleEntityId : Int!
    var roleMemberCount : Int!
    var rolePercentComplete : Int!
    var roleItemRisk : String!
    var rolePolicyCount : Int!
    
    
    init(data : NSDictionary){
        
        self.roleDisplayName = Utils.getStringFromJSON(data, key: "roleDisplayName")
        self.roleEntityId = data["roleEntityId"] as! Int
        self.roleMemberCount = data["roleMemberCount"] as! Int
        self.rolePercentComplete = data["rolePercentComplete"] as! Int
        self.roleItemRisk = Utils.getStringFromJSON(data, key: "roleItemRisk")
        self.rolePolicyCount = data["rolePolicyCount"] as! Int
        
        /*
        "roleDisplayName": "ERP Transaction Manager",
        "roleEntityId": 9,
        "roleMemberCount": 3,
        "rolePercentComplete": 0,
        "roleItemRisk": "High Risk",
        "rolePolicyCount": 0
        */
    }
}

class RoleItemDetail {
    
    var firstName : String!
    var lastName : String!
    var roleId : Int!
    var userEntityId : Int!
    var userLogin : String!
    var riskSummary : String!
    
    
    init(data : NSDictionary){
        
        self.firstName = Utils.getStringFromJSON(data, key: "firstName")
        self.lastName = Utils.getStringFromJSON(data, key: "lastName")
        self.roleId = data["roleId"] as! Int
        self.userEntityId = data["userEntityId"] as! Int
        self.userLogin = Utils.getStringFromJSON(data, key: "userLogin")
        self.riskSummary = Utils.getStringFromJSON(data, key: "riskSummary")
        
        /*
        "firstName": "Danny",
        "lastName": "Crane",
        "roleId": 9,
        "userEntityId": 661,
        "userLogin": "DCRANE",
        "riskSummary": "High Risk"
        */
    }
}

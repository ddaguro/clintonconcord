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

class UserItem {
    
    var firstName : String!
    var lastName : String!
    var roleRiskSummary : String!
    var userEntityId : Int!
    var accountRiskSummary : String!
    var percentComplete : Int!
    var userLogin : String!
    var riskSummary : String!
    var userId : Int!
    
    init(data : NSDictionary){
        
        self.firstName = Utils.getStringFromJSON(data, key: "firstName")
        self.lastName = Utils.getStringFromJSON(data, key: "lastName")
        self.roleRiskSummary = Utils.getStringFromJSON(data, key: "roleRiskSummary")
        self.userEntityId = data["userEntityId"] as! Int
        self.accountRiskSummary = Utils.getStringFromJSON(data, key: "accountRiskSummary")
        self.percentComplete = data["percentComplete"] as! Int
        self.userLogin = Utils.getStringFromJSON(data, key: "userLogin")
        self.riskSummary = Utils.getStringFromJSON(data, key: "riskSummary")
        self.userId = data["userId"] as! Int
        
        /*
        "firstName": "Grace",
        "lastName": "Davis",
        "roleRiskSummary": "High Risk",
        "userEntityId": 486,
        "accountRiskSummary": "Low Risk",
        "entitlementRiskSummary": "Low Risk",
        "percentComplete": 0,
        "userLogin": "GDAVIS",
        "riskSummary": "High Risk",
        "userId": 299
        */
        
    }
}

class UserItemDetail {
    
    var accountId : Int!
    var rowEntityId : String!
    var riskSummary : String!
    var entityType : String!
    var displayName : String!
    
    var userItemDetailEntitlements : [UserItemDetailEntitlements]!
    
    init(data : NSDictionary){
        
        self.accountId = data["accountId"] as! Int
        self.rowEntityId = Utils.getStringFromJSON(data, key: "rowEntityId")
        
        if let entityresults: NSArray = data["entitlements"] as? NSArray {
            
            var ents = [UserItemDetailEntitlements]()
            for ent in entityresults {
                let ent = UserItemDetailEntitlements(data: ent as! NSDictionary)
                ents.append(ent)
            }
            self.userItemDetailEntitlements = ents
        }
        
        self.riskSummary = Utils.getStringFromJSON(data, key: "riskSummary")
        self.entityType = Utils.getStringFromJSON(data, key: "entityType")
        self.displayName = Utils.getStringFromJSON(data, key: "displayName")
        
        /*
        "accountId": 2794,
        "rowEntityId": "625",
        "entitlements": [
            {
            "entitlementDisplayName": "Claims Analyst",
            "accountId": 2794,
            "rowEntityId": "237",
            "entityType": "ACCOUNT_ATTRIBUTE_VALUE"
            },
        ],
        "riskSummary": "Medium Risk",
        "entityType": "ACCOUNT",
        "displayName": "Enterprise Directory(GDAVIS)"
        */
        
    }
}

class UserItemDetailEntitlements {
    var entitlementDisplayName : String!
    var accountId : Int!
    var rowEntityId : String!
    var entityType : String!
    
    init(data : NSDictionary){
        
        self.entitlementDisplayName = Utils.getStringFromJSON(data, key: "entitlementDisplayName")
        self.accountId = data["accountId"] as! Int
        self.rowEntityId = Utils.getStringFromJSON(data, key: "rowEntityId")
        self.entityType = Utils.getStringFromJSON(data, key: "entityType")
    }
}
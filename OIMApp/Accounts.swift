//
//  Accounts.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/19/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation
class Accounts {
    
    var count : String!
    var cursor : String!
    var limit : String!
    
    var applications : Applications!
    var entitlements : Entitlements!
    var roles : Roles!
    
    init(data : NSDictionary){

        
        self.count = Utils.getStringFromJSON(data, key: "count")
        self.cursor = Utils.getStringFromJSON(data, key: "cursor")
        self.limit = Utils.getStringFromJSON(data, key: "limit")
        
        if let appData = data["userAccounts"]!["userAppInstances"] as? NSDictionary {
            self.applications = Applications(data: appData)
        }
        
        if let entData = data["userEntitlements"] as? NSDictionary {
            self.entitlements = Entitlements(data: entData)
        }
        
        if let roleData = data["userRoles"] as? NSDictionary {
            self.roles = Roles(data: roleData)
        }
    }
}
/*
class Accounts {
    
    var appInstances = Applications()
    var entitlements = Entitlements()
    var roles = Roles()
    
    
    init(data : NSDictionary){
        
        var app : String?
        app = Utils.getStringFromJSON(data, key: "appInstanceKey")
        if let result = app {
            self.appInstances.applicationInstanceName = Utils.getStringFromJSON(data, key: "applicationInstanceName")
        }
        
        var ent : String?
        ent = Utils.getStringFromJSON(data, key: "entitlementKey")
        if let result = ent {
            self.entitlements.entitlementName = Utils.getStringFromJSON(data, key: "entitlementName")
        }
        
        var role : String?
        role = Utils.getStringFromJSON(data, key: "roleKey")
        if let result = role {
            self.roles.roleName = Utils.getStringFromJSON(data, key: "roleName")
        }
        

    }
}

class Applications{
    
    var appInstanceKey : String!
    var applicationInstanceName : String!
}

class Entitlements {
    
    var entitlementKey : String!
    var entitlementName : String!
    var entitlementDescription : String!
}

class Roles {
    
    var roleKey : String!
    var roleName : String!
}

*/
//
//  Entitlements.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Entitlements {
    
    var resource : String!
    var status : String!
    var requestID : String!
    var provisionedOnDate : String!
    var applicationInstance : String!
    var accountName : String!
    var entitlementKey : String!
    var entitlementDisplayName : String!
    var entitlementName : String!
    var entitlementDescription : String!
    
    init(data : NSDictionary){
        
        self.resource = Utils.getStringFromJSON(data, key: "resource")
        self.status = Utils.getStringFromJSON(data, key: "status")
        self.requestID = Utils.getStringFromJSON(data, key: "requestID")
        self.provisionedOnDate = Utils.getStringFromJSON(data, key: "provisionedOnDate")
        self.accountName = Utils.getStringFromJSON(data, key: "accountName")
        self.entitlementKey = Utils.getStringFromJSON(data, key: "entitlementKey")
        self.entitlementDisplayName = Utils.getStringFromJSON(data, key: "entitlementDisplayName")
        self.entitlementName = Utils.getStringFromJSON(data, key: "entitlementName")
        self.entitlementDescription = Utils.getStringFromJSON(data, key: "entitlementDescription")
        
        /*
        resource: "TBD resource"
        status: "Provisioned"
        requestID: ""
        provisionedOnDate: "2013-02-01"
        applicationInstance: "TBD appInstanceName"
        accountName: "dcrane"
        entitlementKey: 31
        entitlementDisplayName: "IT Applications"
        entitlementName: "OID Server~IT Applications"
        entitlementDescription: "Access to Information Technology Applications"
        */
        
    }
}

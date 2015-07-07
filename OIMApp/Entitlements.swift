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
    var entitlementKey : Int!
    var entitlementDisplayName : String!
    var entitlementName : String!
    var entitlementDescription : String!
    var catalogId : String!
    
    init(data : NSDictionary){
        
        self.resource = Utils.getStringFromJSON(data, key: "resource")
        self.status = Utils.getStringFromJSON(data, key: "status")
        self.requestID = Utils.getStringFromJSON(data, key: "requestID")
        self.provisionedOnDate = Utils.getStringFromJSON(data, key: "provisionedOnDate")
        self.accountName = Utils.getStringFromJSON(data, key: "accountName")
        self.entitlementKey = data["entitlementKey"] as! Int
        self.entitlementDisplayName = Utils.getStringFromJSON(data, key: "entitlementDisplayName")
        self.entitlementName = Utils.getStringFromJSON(data, key: "entitlementName")
        self.entitlementDescription = Utils.getStringFromJSON(data, key: "entitlementDescription")
        self.catalogId = Utils.getStringFromJSON(data, key: "catalogId")
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
class EntitlementItem {
    
    var percentComplete : Int!
    var belongsToMe : String!
    var certificationId : Int!
    var entitlementId : Int!
    var applicationInstanceName : String!
    var entitlementDisplayName : String!
    var itemRisk : String!
    var accounts : Int!
    var entityType : String!
    var certificationType : String!
    var attributeName : String!
    
    init(data : NSDictionary){
        
        self.percentComplete = data["percentComplete"] as! Int
        self.belongsToMe = Utils.getStringFromJSON(data, key: "belongsToMe")
        self.certificationId = data["certificationId"] as! Int
        self.entitlementId = data["entitlementId"] as! Int
        self.applicationInstanceName = Utils.getStringFromJSON(data, key: "applicationInstanceName")
        self.entitlementDisplayName = Utils.getStringFromJSON(data, key: "entitlementDisplayName")
        self.itemRisk = Utils.getStringFromJSON(data, key: "itemRisk")
        self.accounts = data["accounts"] as! Int
        self.entityType = Utils.getStringFromJSON(data, key: "entityType")
        self.certificationType = Utils.getStringFromJSON(data, key: "certificationType")
        self.attributeName = Utils.getStringFromJSON(data, key: "attributeName")
        
        /*
        percentComplete: 0
        belongsToMe: "1"
        certificationId: 122
        entitlementId: 88
        applicationInstanceName: "Physical Badge Access"
        entitlementDisplayName: "West Data Center"
        itemRisk: "Low Risk"
        accounts: 4
        entityType: "Entitlement"
        certificationType: "Entitlement"
        attributeName: "Facility Name"
        */
        
    }
}

class EntitlementItemDetail {
    
    var certificationId : Int!
    var lastName : String!
    var firstName : String!
    var accountName : String!
    var riskSummary : String!
    var userLogin : String!
    var certificationType : String!
    var entityId : Int!
    var userId : Int!
    
    init(data : NSDictionary){
        
        self.certificationId = data["certificationId"] as! Int
        self.lastName = Utils.getStringFromJSON(data, key: "lastName")
        self.firstName = Utils.getStringFromJSON(data, key: "firstName")
        self.accountName = Utils.getStringFromJSON(data, key: "accountName")
        self.riskSummary = Utils.getStringFromJSON(data, key: "riskSummary")
        self.userLogin = Utils.getStringFromJSON(data, key: "userLogin")
        self.certificationType = Utils.getStringFromJSON(data, key: "certificationType")
        self.entityId = data["entityId"] as! Int
        self.userId = data["userId"] as! Int
        
        /*
        certificationId: 122
        lastName: "Jurado"
        firstName: "Brigitte"
        accountName: "B733725"
        riskSummary: "Medium Risk"
        userLogin: "B733725"
        certificationType: "Entitlement"
        entityId: 223
        userId: 5908
        */
        
    }
}
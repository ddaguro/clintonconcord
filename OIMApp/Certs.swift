//
//  Certs.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/18/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Certs {
    
    var percentComplete : String!
    var certificationId : Int!
    var asignee : String!
    var createdDate : String!
    var certificationType : String!
    var title : String!
    var state : String!
    
    
    init(data : NSDictionary){
        
        self.percentComplete = Utils.getStringFromJSON(data, key: "percentComplete")
        self.certificationId = data["certificationId"] as! Int
        self.asignee = Utils.getStringFromJSON(data, key: "asignee")
        self.createdDate = Utils.getStringFromJSON(data, key: "createdDate")
        self.certificationType = Utils.getStringFromJSON(data, key: "certificationType")
        
        let sTitle = Utils.getStringFromJSON(data, key: "title")
        let needle: Character = "["
        if let idx = find(sTitle, needle) {
            let pos = distance(sTitle.startIndex, idx)
            self.title = sTitle.substringToIndex(advance(sTitle.startIndex,pos))
        }
        else {
            self.title = Utils.getStringFromJSON(data, key: "title")
        }
        
        //self.title = Utils.getStringFromJSON(data, key: "title")
        self.state = Utils.getStringFromJSON(data, key: "state")
        
    }
    
    /* sample data
    
    certificationId: 5
    asignee: "dcrane"
    createdDate: "Wed Jun 17 09:02:40 EDT 2015"
    certificationType: "ApplicationInstance"
    title: "Application Instance Certification [ Danny Crane ] "
    state: "New"
    
    */
    
}

class CertItem {
    
    var percentComplete : Int!
    var itemRisk : String!
    var certificationId : Int!
    var applicationInstanceId : Int!
    var applicationInstanceName : String!
    var resourceType : String!
    var accounts : Int!
    var entitlements : Int!
    var certificationType : String!
    
    init(data : NSDictionary){
        self.certificationId = data["certificationId"] as! Int
        self.percentComplete =  data["percentComplete"] as! Int
        self.itemRisk = Utils.getStringFromJSON(data, key: "itemRisk")
        self.applicationInstanceId = data["applicationInstanceId"] as! Int
        self.certificationType = Utils.getStringFromJSON(data, key: "certificationType")
        self.applicationInstanceName = Utils.getStringFromJSON(data, key: "applicationInstanceName")
        self.resourceType = Utils.getStringFromJSON(data, key: "resourceType")
        self.accounts = data["accounts"] as! Int
        self.entitlements = data["entitlements"] as! Int
        self.certificationType = Utils.getStringFromJSON(data, key: "certificationType")
        
    }
    
    /* sample data
    
    percentComplete: 0
    itemRisk: "Low Risk"
    certificationId: 49
    applicationInstanceId: 97
    applicationInstanceName: "Physical Badge Access"
    resourceType: "PhysicalBadge"
    accounts: 1
    entitlements: 0
    certificationType: "ApplicationInstance"
    
    */
    
}

class CertItemDetail {
    
    var certificationId : Int!
    var entityId : Int!
    
    var appAccounts : [AppAccounts]!
    
    init(data : NSDictionary){
        
        self.certificationId = data["certificationId"] as! Int
        self.entityId = data["entityId"] as! Int
        
        if let results: NSArray = data["accounts"] as? NSArray {
            var accts = [AppAccounts]()
            for act in results{
                let act = AppAccounts(data: act as! NSDictionary)
                accts.append(act)
            }
            self.appAccounts = accts
        }
    }
    
    /* sample data
    
    certificationLineItemDetails: [1]
    0:  {
    certificationId: 22
    accounts: [1]
    0:  {
    rowEntityId: "3"
    targetAccountUserLogin: "KCLARK"
    entitlements: [0]
    displayName: "Physical Badge Access(kclark)"
    }-
    -
    entityId: 43
    }-
    -
    requesterId: "dcrane"
    certificationType: "ApplicationInstance"
    }
    
    */
    
}


class AppAccounts {
    var rowEntityId : String!
    var targetAccountUserLogin : String!
    var displayName : String!
    var riskSummary : String!
    
    init(data : NSDictionary){
        
        self.rowEntityId = Utils.getStringFromJSON(data, key: "rowEntityId")
        self.targetAccountUserLogin = Utils.getStringFromJSON(data, key: "targetAccountUserLogin")
        self.displayName = Utils.getStringFromJSON(data, key: "displayName")
        self.riskSummary = Utils.getStringFromJSON(data, key: "riskSummary")
        
        
        /*
        rowEntityId: "3"
        targetAccountUserLogin: "KCLARK"
        entitlements: [0]
        displayName: "Physical Badge Access(kclark)"
        */
    }
}
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
    var accounts : String!
    var entitlements : String!
    var certificationType : String!
    
    init(data : NSDictionary){
        
        self.percentComplete =  data["percentComplete"] as! Int
        self.itemRisk = Utils.getStringFromJSON(data, key: "itemRisk")
        self.applicationInstanceId = data["applicationInstanceId"] as! Int
        self.certificationType = Utils.getStringFromJSON(data, key: "certificationType")
        self.applicationInstanceName = Utils.getStringFromJSON(data, key: "applicationInstanceName")
        self.resourceType = Utils.getStringFromJSON(data, key: "resourceType")
        self.accounts = Utils.getStringFromJSON(data, key: "accounts")
        self.entitlements = Utils.getStringFromJSON(data, key: "entitlements")
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
    
    var rowEntityId : String!
    var targetAccountUserLogin : String!
    var lastCertificationActionDetails : String!
    var displayName : String!
    
    init(data : NSDictionary){
        
        self.rowEntityId = Utils.getStringFromJSON(data, key: "rowEntityId")
        self.targetAccountUserLogin = Utils.getStringFromJSON(data, key: "targetAccountUserLogin")
        self.lastCertificationActionDetails = Utils.getStringFromJSON(data, key: "lastCertificationActionDetails")
        self.displayName = Utils.getStringFromJSON(data, key: "displayName")
    }
    
    /* sample data
    
    rowEntityId: "3"
    targetAccountUserLogin: "KCLARK"
    lastCertificationActionDetails: "Action : Certify Taken By : Danny Crane Date : Fri Jun 19 17:15:36 EDT 2015"
    entitlements: [0]
    displayName: "Physical Badge Access(kclark)"
    
    */
    
}
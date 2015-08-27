//
//  Applications.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Applications {
    
    var status : String!
    var provisionedOnDate : String!
    var accountType : String!
    var requestKey : String!
    var accountDescriptiveField : String!
    var displayName : String!
    var description : String!
    var applicationInstanceName : String!
    var dataSetName : String!
    var uiFragmentName : String!
    var appInstanceKey : Int!
    var catagoryId : String!
    
    
    /* sample data
    
    "provisionedOnDate": "2015-06-18",
    "accountType": "unknown",
    "requestKey": "6008",
    "accountDescriptiveField": "2323",
    "status": "Provisioning",
    "appInstanceKey": 1,
    "applicationInstanceName": "PhysicalBadge",
    "dataSetName": "PhysicalBadge",
    "catalogId": "1",
    "uiFragmentName": "PhysicalBadge",
    "description": "Provides physical badge / smartcard to access enterprise facilities",
    "displayName": "Physical Badge Access"
    
    */
    
    init(data : NSDictionary){
        
        self.status = Utils.getStringFromJSON(data, key: "status")
        self.provisionedOnDate = Utils.getStringFromJSON(data, key: "provisionedOnDate")
        self.displayName = Utils.getStringFromJSON(data, key: "displayName")
        self.description = Utils.getStringFromJSON(data, key: "description")
        self.displayName = Utils.getStringFromJSON(data, key: "displayName")
        self.applicationInstanceName = Utils.getStringFromJSON(data, key: "applicationInstanceName")
        self.catagoryId = Utils.getStringFromJSON(data, key: "catalogId")
        self.appInstanceKey = data["appInstanceKey"] as! Int
        
    }
}
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
    var appInstanceKey : String!
    var catagoryId : String!
    
    
    /* sample data

    status: "Provisioned"
    provisionedOnDate: "2013-02-28"
    accountType: "primary"
    requestKey: "34"
    accountDescriptiveField: "dcrane"
    displayName: "Badge Access"
    description: "Badge Access for physical access control"
    applicationInstanceName: "badging"
    dataSetName: "badging"
    uiFragmentName: "badging"
    appInstanceKey: 1
    
    */
    
    init(data : NSDictionary){
        
        self.status = Utils.getStringFromJSON(data, key: "status")
        self.provisionedOnDate = Utils.getStringFromJSON(data, key: "provisionedOnDate")
        self.displayName = Utils.getStringFromJSON(data, key: "displayName")
        self.description = Utils.getStringFromJSON(data, key: "description")
        self.displayName = Utils.getStringFromJSON(data, key: "displayName")
        self.applicationInstanceName = Utils.getStringFromJSON(data, key: "applicationInstanceName")
        self.catagoryId = Utils.getStringFromJSON(data, key: "catagoryId")
        
    }
}
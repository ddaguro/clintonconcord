//
//  Requests.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Requests {
    
    //var usr_key : String!
    var reqCreatedOn : String!
    var reqExpireOn : String!
    var reqId : String!
    var reqJustification : String!
    var reqStatus : String!
    var reqTargetEntities : String!
    var reqType : String!
    var requester : String!
    
    init(data : NSDictionary){
        
        self.reqId = Utils.getStringFromJSON(data, key: "reqId")
        self.reqJustification = Utils.getStringFromJSON(data, key: "reqJustification")
        self.reqStatus = Utils.getStringFromJSON(data, key: "reqStatus")
        self.reqType = Utils.getStringFromJSON(data, key: "reqType")
        self.reqCreatedOn = Utils.getStringFromJSON(data, key: "reqCreatedOn")
        
    }
}

struct BeneficiaryList {
    var user_key : String!
}

struct TargetEntities {
    var entity : String!
}
//
//  Activities.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 8/18/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Activities {
    
    var reqId : String!
    var reqStatus : String!
    var reqCreatedOn : String!
    var reqExpireOn : String!
    var reqType : String!
    var reqModifiedOnDate : String!
    var requester : String!
    
    var reqBeneficiaryList : [ReqBeneficiaryList]!
    var reqTargetEntities : [ReqTargetEntities]!
    var currentApprovers : [CurrentApprovers]!
    
    init(data : NSDictionary){
        
        if let beneficiaryresults: NSArray = data["reqBeneficiaryList"] as? NSArray {
            
            var beneficiary = [ReqBeneficiaryList]()
            for ben in beneficiaryresults {
                let ben = ReqBeneficiaryList(data: ben as! NSDictionary)
                beneficiary.append(ben)
            }
            self.reqBeneficiaryList = beneficiary
        }
        
        self.reqId = Utils.getStringFromJSON(data, key: "reqId")
        
        self.reqStatus = Utils.getStringFromJSON(data, key: "reqStatus")
        self.reqCreatedOn = Utils.getStringFromJSON(data, key: "reqCreatedOn")
        self.reqExpireOn = Utils.getStringFromJSON(data, key: "reqExpireOn")
        self.reqType = Utils.getStringFromJSON(data, key: "reqType")
        self.reqModifiedOnDate = Utils.getStringFromJSON(data, key: "reqModifiedOnDate")
        self.requester = Utils.getStringFromJSON(data, key: "requester")
        
        if let entityresults: NSArray = data["reqTargetEntities"] as? NSArray {
            
            var ents = [ReqTargetEntities]()
            for ent in entityresults {
                let ent = ReqTargetEntities(data: ent as! NSDictionary)
                ents.append(ent)
            }
            self.reqTargetEntities = ents
        }
        
        /*
        if let approveresults: NSArray = data["currentApprovers"] as? NSArray {
            
            var approver = [CurrentApprovers]()
            for app in approveresults {
                let app = CurrentApprovers(data: app as! NSDictionary)
                approver.append(app)
            }
            self.currentApprovers = approver
        } else {
            self.currentApprovers = nil
        }
        */
    }
}

class ReqBeneficiaryList {
    var beneficiary : String!
    
    init(data : NSDictionary){
        
        self.beneficiary = Utils.getStringFromJSON(data, key: "User Login")
    }
}

class ReqTargetEntities {
    var catalogid: String!
    var entityid: String!
    var entitytype: String!
    var entityname: String!
    
    init(data : NSDictionary){
        
        self.catalogid = Utils.getStringFromJSON(data, key: "catalogId")
        self.entityid = Utils.getStringFromJSON(data, key: "entityId")
        self.entitytype = Utils.getStringFromJSON(data, key: "entityType")
        self.entityname = Utils.getStringFromJSON(data, key: "entityName")
    }
}

class CurrentApprovers {
    var approvers : String!
    var status : String!
    var stage : String!
    
    init(data : NSDictionary){
        
        self.approvers = Utils.getStringFromJSON(data, key: "approvers")
        self.status = Utils.getStringFromJSON(data, key: "status")
        self.stage = Utils.getStringFromJSON(data, key: "stage")
    }
}

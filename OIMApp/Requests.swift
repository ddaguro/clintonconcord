//
//  Requests.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

public class Requests {
    
    var reqId : String!
    var reqStatus : String!
    var reqCreatedOn : String!
    var reqType : String!
    var reqJustification : String!
    var reqTargetEntities : [TargetEntities]!
    var reqBeneficiaryList : [BeneficiaryList]!
    
    init(data : NSDictionary){
        
        self.reqId = Utils.getStringFromJSON(data, key: "reqId")
        self.reqStatus = Utils.getStringFromJSON(data, key: "reqStatus")
        self.reqCreatedOn = Utils.getStringFromJSON(data, key: "reqCreatedOn")
        self.reqType = Utils.getStringFromJSON(data, key: "reqType")
        self.reqJustification = Utils.getStringFromJSON(data, key: "reqJustification")
        
        if let results: NSArray = data["reqTargetEntities"] as? NSArray {
            
            var ents = [TargetEntities]()
            for ent in results{
                let ent = TargetEntities(data: ent as! NSDictionary)
                ents.append(ent)
            }
            self.reqTargetEntities = ents
        }
        
        if let beneficiaryresults: NSArray = data["reqBeneficiaryList"] as? NSArray {
            
            var bens = [BeneficiaryList]()
            for ben in beneficiaryresults {
                let ben = BeneficiaryList(data: ben as! NSDictionary)
                bens.append(ben)
            }
            self.reqBeneficiaryList = bens
        }
    }
}

class TargetEntities {
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

class BeneficiaryList {
    var userlogin: String!
    var displayname: String!
    
    init(data : NSDictionary){
        self.userlogin = Utils.getStringFromJSON(data, key: "User Login")
        self.displayname = Utils.getStringFromJSON(data, key: "Display Name")
    }
}

class OperationCounts {
    
    var approvals : Int!
    var certifications : Int!
    var requests : Int!
    
    
    init(data : NSDictionary){
        
        self.approvals = data["approvals"] as! Int
        self.certifications = data["certifications"] as! Int
        self.requests = data["requests"] as! Int
        
    }
}


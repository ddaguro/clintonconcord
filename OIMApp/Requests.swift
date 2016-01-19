//
//  Requests.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

public class Requests {
    
    var reqType : String!
    var reqId : String!
    var requester : String!
    var reqCreatedOn : String!
    var reqJustification : String!
    var reqStatus : String!
    var reqTargetEntities : [TargetEntities]!
    var reqTargetNames : String!
    
    
    
    init(data : NSDictionary){
        
        self.reqId = Utils.getStringFromJSON(data, key: "reqId")
        self.reqJustification = Utils.getStringFromJSON(data, key: "reqJustification")
        self.reqStatus = Utils.getStringFromJSON(data, key: "reqStatus")
        self.reqType = Utils.getStringFromJSON(data, key: "reqType")
        self.reqCreatedOn = Utils.getStringFromJSON(data, key: "reqCreatedOn")
        
        //let results: NSArray = jsonData["requests"] as! NSArray
        
        if let results: NSArray = data["reqTargetEntities"] as? NSArray {
            //println(data["reqTargetEntities"])
            
            var ents = [TargetEntities]()
            for ent in results{
                let ent = TargetEntities(data: ent as! NSDictionary)
                ents.append(ent)
                //self.reqTargetNames = ent
                //var names = (names + ent) as! String
                //self.reqTargetNames += "\(ent)" as! String
                //names.append(ent as! String)
                
                //var variableString = ent as! String
                //variableString += ent as! String
                
                
                
                //self.reqTargetNames = variableString
            }
            self.reqTargetEntities = ents
        }
        
        /* sample data

reqType: "Heterogeneous Request"
reqBeneficiaryList: [1]
0:  {
User Login: "Danny Crane"
}-
-
reqTargetEntities: [2]
0:  "Physical Badge Access"
1:  "East Data Center"
-
childRequestIds: [2]
0:  "6008"
1:  "6009"
-
reqId: "6006"
requester: "dcrane"
reqCreatedOn: "Thu Jun 18 15:38:17 EDT 2015"
reqJustification: "Required access to update servers"
reqStatus: "Request Awaiting Child Requests Completion"

*/
        
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


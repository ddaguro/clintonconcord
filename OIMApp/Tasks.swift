//
//  Tasks.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

public class Tasks {
    
    var requestId : String!
    var taskId : String!
    var taskNumber : String!
    var requestStatus : String!
    var taskPriority : String!
    var taskTitle : String!
    var taskState : String!
    var taskAssignedOn : String!
    var requestType : String!
    var taskApprovalStage : String!
    var taskStageParticipantName : String!
    var requestRaisedByUser : String!
    var requestJustification : String!
    var requestedDate : String!
    
    var requestRaisedByUserId : String!
    var requesterAvatarUrl : String!
    var taskUpdatedOnDate : String!
    
    var beneficiaryUser : [BeneficiaryUser]!
    var requestEntityName : [RequestEntityName]!
    
    var taskpreviousapprover : [TaskPreviousApprover]!
    var taskcurrentapprover : [TaskCurrentApprover]!
    
    init(data : NSDictionary){
        
        self.taskId = Utils.getStringFromJSON(data, key: "taskId")
        self.taskNumber = Utils.getStringFromJSON(data, key: "taskNumber")
        // assignees
        self.requestStatus = Utils.getStringFromJSON(data, key: "requestStatus")
        // requestTaskDetails
        if let previousapproverresults: NSArray = data["requestTaskDetails"] as? NSArray {
            
            var previoustsks = [TaskPreviousApprover]()
            for previoustsk in previousapproverresults {
                let previoustsk = TaskPreviousApprover(data: previoustsk as! NSDictionary)
                previoustsks.append(previoustsk)
            }
            self.taskpreviousapprover = previoustsks
        }
        if let previouscurrentresults: NSArray = data["requestTaskDetails"] as? NSArray {
            
            var currenttsks = [TaskCurrentApprover]()
            for currenttsk in previouscurrentresults {
                let currenttsk = TaskCurrentApprover(data: currenttsk as! NSDictionary)
                currenttsks.append(currenttsk)
            }
            self.taskcurrentapprover = currenttsks
        }
        self.requestRaisedByUserId = Utils.getStringFromJSON(data, key: "requestRaisedByUserId")
        self.requesterAvatarUrl = Utils.getStringFromJSON(data, key: "requesterAvatarUrl")
        self.requestType = Utils.getStringFromJSON(data, key: "requestType")
        self.taskPriority = Utils.getStringFromJSON(data, key: "taskPriority")
        // requestEntityName
        if let entityresults: NSArray = data["requestEntityName"] as? NSArray {
            
            var ents = [RequestEntityName]()
            for ent in entityresults {
                let ent = RequestEntityName(data: ent as! NSDictionary)
                ents.append(ent)
            }
            self.requestEntityName = ents
        }
        self.taskAssignedOn = Utils.getStringFromJSON(data, key: "taskAssignedOn")
        self.taskState = Utils.getStringFromJSON(data, key: "taskState")
        self.taskApprovalStage = Utils.getStringFromJSON(data, key: "taskApprovalStage")
        self.taskStageParticipantName = Utils.getStringFromJSON(data, key: "taskStageParticipantName")
        self.requestRaisedByUser = Utils.getStringFromJSON(data, key: "requestRaisedByUser")
        self.requestJustification = Utils.getStringFromJSON(data, key: "requestJustification")
        self.requestedDate = Utils.getStringFromJSON(data, key: "requestedDate")
        self.taskUpdatedOnDate = Utils.getStringFromJSON(data, key: "taskUpdatedOnDate")
        // beneficiearyUser
        if let beneficiaryresults: NSArray = data["beneficiearyUser"] as? NSArray {
            
            var bens = [BeneficiaryUser]()
            for ben in beneficiaryresults {
                let ben = BeneficiaryUser(data: ben as! String)
                bens.append(ben)
            }
            self.beneficiaryUser = bens
        }
        self.taskTitle = Utils.getStringFromJSON(data, key: "taskTitle")
        self.requestId = Utils.getStringFromJSON(data, key: "requestId")
    }
}

class TaskPreviousApprover {

    var requesttaskapprovers : [RequestTaskApprovers]!
    
    init(data : NSDictionary){
        if let taskresults: NSArray = data["history"]!["previousApprovers"] as? NSArray {

            var approvers = [RequestTaskApprovers]()
            for app in taskresults {
                let app = RequestTaskApprovers(data: app as! NSDictionary)
                approvers.append(app)
            }
            self.requesttaskapprovers = approvers
        }
    }
}

class TaskCurrentApprover {
    
    var requesttaskapprovers : [RequestTaskApprovers]!
    
    init(data : NSDictionary){
        if let taskresults: NSArray = data["history"]!["currentApprovers"] as? NSArray {
            
            var approvers = [RequestTaskApprovers]()
            for app in taskresults {
                let app = RequestTaskApprovers(data: app as! NSDictionary)
                approvers.append(app)
            }
            self.requesttaskapprovers = approvers
        }
    }
}

class RequestTaskApprovers {
    var updatedDate : String!
    var approvers : String!
    var stageIndex : String!
    var status : String!
    var stage : String!
    
    init(data : NSDictionary){
        self.updatedDate = Utils.getStringFromJSON(data, key: "updatedDate")
        self.approvers = Utils.getStringFromJSON(data, key: "approvers")
        self.stageIndex = Utils.getStringFromJSON(data, key: "stageIndex")
        self.status = Utils.getStringFromJSON(data, key: "status")
        self.stage = Utils.getStringFromJSON(data, key: "stage")
    }
}

class RequestEntityName {
    var entityname : String!
    init(data : NSDictionary){
        self.entityname = Utils.getStringFromJSON(data, key: "entityName")
    }
}

class BeneficiaryUser {
    var beneficiary : String!
    init(data : String) {
        self.beneficiary = data
    }
}
//
//  Tasks.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class Tasks {
    
    var requestId : String!
    var taskId : String!
    var taskNumber : String!
    var requestStatus : String!
    var taskPriority : String!
    var taskTitle : String!
    var taskState : String!
    var taskAssignedOn : String!
    var requestType : String!
    var requestEntityName : String!
    var taskApprovalStage : String!
    var taskStageParticipantName : String!
    var requestRaisedByUser : String!
    var beneficiearyUser : String!
    var requestJustification : String!
    var requestedDate : String!
    
    init(data : NSDictionary){
        
        self.requestId = Utils.getStringFromJSON(data, key: "requestId")
        self.taskId = Utils.getStringFromJSON(data, key: "taskId")
        self.taskNumber = Utils.getStringFromJSON(data, key: "taskNumber")
        self.requestStatus = Utils.getStringFromJSON(data, key: "requestStatus")
        self.taskPriority = Utils.getStringFromJSON(data, key: "taskPriority")
        self.taskTitle = Utils.getStringFromJSON(data, key: "taskTitle")
        self.taskState = Utils.getStringFromJSON(data, key: "taskState")
        self.taskAssignedOn = Utils.getStringFromJSON(data, key: "taskAssignedOn")
        self.requestType = Utils.getStringFromJSON(data, key: "requestType")
        self.requestEntityName = Utils.getStringFromJSON(data, key: "requestEntityName")
        self.taskApprovalStage = Utils.getStringFromJSON(data, key: "taskApprovalStage")
        self.taskStageParticipantName = Utils.getStringFromJSON(data, key: "taskStageParticipantName")
        self.requestRaisedByUser = Utils.getStringFromJSON(data, key: "requestRaisedByUser")
        self.beneficiearyUser = Utils.getStringFromJSON(data, key: "beneficiearyUser")
        self.requestJustification = Utils.getStringFromJSON(data, key: "requestJustification")
        self.requestedDate = Utils.getStringFromJSON(data, key: "requestedDate")
        
    }
    
    /* sampel data
    
    requestId: "1160"
    taskId: "1a568e4d-17fa-4ff1-b069-4140d00f69da"
    taskNumber: "200994"
    requestStatus: "Obtaining Operation Approval"
    taskPriority: "3"
    taskTitle: "Beneficiary manager approval for Request ID 1160"
    taskState: "ASSIGNED"
    taskAssignedOn: "Mon Jun 01 22:00:18 CDT 2015"
    requestType: "Provision Entitlement"
    requestEntityName: "Health Club"
    taskApprovalStage: "Stage1"
    taskStageParticipantName: "Assignee1"
    requestRaisedByUser: "Ben Jones"
    beneficiearyUser: "Ben Jones"
    requestJustification: "Family Workouts"
    requestedDate: "Mon Jun 01 22:00:16 CDT 2015"
    
    */
    
}
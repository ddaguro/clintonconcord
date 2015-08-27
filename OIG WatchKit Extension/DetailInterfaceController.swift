//
//  DetailInterfaceController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 8/24/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    let endpoint = "http://idaasapi.persistent.com:9080/"
    let baseroot = "idaas/oig/v1"
    let myLoginId = "dcrane"
    var paramstring : String = ""
    var tasks : Tasks!
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var approveBtn: WKInterfaceButton!
    @IBOutlet var approveLabel: WKInterfaceLabel!
    @IBOutlet var declineBtn: WKInterfaceButton!
    @IBOutlet var declineLabel: WKInterfaceLabel!
    @IBOutlet var beneficiaryLabel: WKInterfaceLabel!
    @IBOutlet var descriptionLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!
    
    @IBOutlet var profileImage: WKInterfaceImage!
    
    @IBAction func ApproveAction() {
        let url = endpoint + baseroot + "/approvals"
        
        RequestApprovalAction(myLoginId, params : paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                println("Action Successful")
                self.pushControllerWithName("InterfaceController", context: self)
                self.dismissController()
            }
            else {
                println("Action Failed")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(succeeded) {
                    
                }
            })
        }
    }
    
    @IBAction func DeclineAction() {
        self.pushControllerWithName("InterfaceController", context: self)
        self.dismissController()
    }
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let tasks = context as? Tasks {
            self.tasks = tasks
            //setTitle(tasks.requestEntityName)
            //NSLog("\(self.tasks)")
            
            
            var titleText = ""
            for ent in tasks.requestEntityName {
                if titleText.isEmpty {
                    titleText = ent.entityname
                } else {
                    titleText += " , \(ent.entityname)"
                }
            }
            titleLabel.setText(titleText)
            var beneficiaryText = ""
            for ben in tasks.beneficiaryUser {
                if beneficiaryText.isEmpty {
                    beneficiaryText = ben.beneficiary
                } else {
                    beneficiaryText += " , \(ben.beneficiary)"
                }
            }
            
            if beneficiaryText == "Kevin Clark" {
                profileImage.setImage(UIImage(named: "kclark"))
            } else if beneficiaryText == "Grace Davis" {
                profileImage.setImage(UIImage(named: "gdavis"))
            } else if beneficiaryText == "Danny Crane" {
                profileImage.setImage(UIImage(named: "dcrane"))
            } else {
                profileImage.setImage(UIImage(named: "profileBlankPic"))
            }
            
            beneficiaryLabel.setText(beneficiaryText)
            descriptionLabel.setText(tasks.requestJustification)
            dateLabel.setText(formatDate(tasks.requestedDate))
            approveBtn.setBackgroundImage(UIImage(named: "btn-approve"))
            approveLabel.setText("APPROVE")
            declineBtn.setBackgroundImage(UIImage(named: "btn-decline"))
            declineLabel.setText("DECLINE")
            
            paramstring = "{\"requester\": {\"User Login\": \""
            paramstring += myLoginId + "\"},\"task\": [{\"requestId\": \""
            paramstring += tasks.requestId + "\",\"taskId\": \""
            paramstring += tasks.taskId + "\", \"taskNumber\": \""
            paramstring += tasks.taskNumber + "\",\"taskPriority\": \""
            paramstring += tasks.taskPriority + "\",\"taskState\": \""
            paramstring += tasks.taskState + "\",\"taskTitle\": \""
            paramstring += tasks.taskTitle + "\" ,\"taskActionComments\": \""
            paramstring += "Apple Watch" + "\",\"taskAction\": \""
            paramstring += "APPROVE" + "\"}]}"
            
        }
    }
    
    func formatDate(dateString: String) -> String {
        
        let formatter = NSDateFormatter()
        //Thu Aug 13 18:19:07 EDT 2015
        formatter.dateFormat = "EEE MMM dd H:mm:ss yyyy" //yyyy-MM-dd'T'HH:mm:ssZ
        let date = formatter.dateFromString(dateString.stringByReplacingOccurrencesOfString("EDT", withString: ""))
        
        formatter.dateFormat = "EEE, MMM dd h:mm a"
        return formatter.stringFromDate(date!)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func RequestApprovalAction(loginId : String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            if(err != nil) {
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                if let parseJSON = json {
                    var info : NSArray =  json!.valueForKey("results") as! NSArray
                    var success: Bool? = info[0].valueForKey("isSuccess") as? Bool
                    
                    if success == true {
                        postCompleted(succeeded: true, msg: "Approved Request")
                    } else {                        postCompleted(succeeded: false, msg: "Approved Request Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
}
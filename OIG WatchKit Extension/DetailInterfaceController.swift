//
//  DetailInterfaceController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 8/24/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DetailInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    let endpoint = "http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9441/"
    let baseroot = "idaas/im/v1"
    let myLoginId = "dcrane"
    var username : String = ""
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
        
        var user = "" as String!
        if self.username == "" {
            user = "dcrane"
        } else {
            user = self.username
        }
        
        RequestApprovalAction(user, params : paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                print("Action Successful")
                self.pushControllerWithName("InterfaceController", context: self)
                self.dismissController()
            }
            else {
                print("Action Failed")
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
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        let emoji = userInfo["user"] as? String
        self.username = emoji!
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var user = "" as String!
        if self.username == "" {
            user = "dcrane"
        } else {
            user = self.username
        }
        
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
                profileImage.setImage(UIImage(named: "w-kclark"))
            } else if beneficiaryText == "Grace Davis" {
                profileImage.setImage(UIImage(named: "w-gdavis"))
            } else if beneficiaryText == "Danny Crane" {
                profileImage.setImage(UIImage(named: "w-dcrane"))
            } else {
                profileImage.setImage(UIImage(named: "w-profileblank"))
            }
            
            beneficiaryLabel.setText(beneficiaryText)
            descriptionLabel.setText(tasks.requestJustification)
            dateLabel.setText(formatDate(tasks.requestedDate))
            approveBtn.setBackgroundImage(UIImage(named: "w-btn-approve"))
            approveLabel.setText("APPROVE")
            declineBtn.setBackgroundImage(UIImage(named: "w-btn-decline"))
            declineLabel.setText("DECLINE")
            
            paramstring = "{\"requester\": {\"User Login\": \""
            paramstring += user + "\"},\"task\": [{\"requestId\": \""
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
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue("TestClient", forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                if let parseJSON = json {
                    let info : NSArray =  parseJSON.valueForKey("results") as! NSArray
                    let success: Bool? = info[0].valueForKey("isSuccess") as? Bool
                    
                    if success == true {
                        postCompleted(succeeded: true, msg: "Approved Request")
                    } else {                        postCompleted(succeeded: false, msg: "Approved Request Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
}
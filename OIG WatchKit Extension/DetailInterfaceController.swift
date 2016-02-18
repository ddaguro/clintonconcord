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
    
    let myEndpoint = "http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9441/idaas/im/v1"
    let myLoginId = "dcrane"
    let myPassword = "Oracle123"
    
    var paramstring : String = ""
    
    var username : String = ""
    var password : String = ""
    
    var watchtoken : String = ""
    var watchapi : String = ""
    
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
        
        var user = "" as String!
        var pwd = "" as String!
        var api = "" as String!
        if self.username == "" {
            user = myLoginId
            pwd = myPassword
            api = myEndpoint
        } else {
            user = self.username
            pwd = self.password
            api = self.watchapi
        }
        
        let url2 = api + "/users/login"
        let paramstring2 = "username=" + user + "&password=" + pwd
        
        LogIn(paramstring2, url : url2) { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                let url = api + "/approvals"
                
                self.RequestApprovalAction(user, params : self.paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
                    if(succeeded) {
                        //print("Action Successful")
                        self.pushControllerWithName("InterfaceController", context: self)
                        self.dismissController()
                    }
                    else {
                        //print("Action Failed")
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if(succeeded) {
                            
                        }
                    })
                }
            }
            else {
            }
        }
    }
    
    @IBAction func DeclineAction() {
        self.pushControllerWithName("InterfaceController", context: self)
        self.dismissController()
    }
    
    override init() {
        super.init()
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        let watchdata = userInfo["data"] as? String
        
        let loginInfo: String = watchdata!
        let loginInfoArray = loginInfo.componentsSeparatedByString(",")
        
        let watchuser: String = loginInfoArray[0]
        let watchpwd: String = loginInfoArray[1]
        let watchapi: String = loginInfoArray[2]
        
        if watchdata != nil {
            self.username = watchuser
            self.password = watchpwd
            self.watchapi = watchapi
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var user = "" as String!
        if self.username == "" {
            user = myLoginId
        } else {
            user = self.username
        }
        
        if let tasks = context as? Tasks {
            self.tasks = tasks
            
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
        return dateString
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
        request.addValue("DevClient", forHTTPHeaderField: "clientId")
        request.addValue(watchtoken, forHTTPHeaderField: "authorization")
        
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
                    } else {
                        postCompleted(succeeded: false, msg: "Approved Request Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    //print("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
    
    func LogIn(params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("DevClient", forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                if let parseJSON = json {
                    let success = parseJSON["isAuthenticated"] as? Int
                    if success == 1 {
                        
                        self.watchtoken = parseJSON["encodedValue"] as! String
                        postCompleted(succeeded: true, msg: "Successful")
                    } else {
                        postCompleted(succeeded: false, msg: "Incorrect username and password")
                        
                    }
                    return
                }
                else {
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        task.resume()
    }
}
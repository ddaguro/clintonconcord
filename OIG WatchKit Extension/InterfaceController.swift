//
//  InterfaceController.swift
//  OIG WatchKit Extension
//
//  Created by Linh NGUYEN on 8/24/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    @IBOutlet var approveTable: WKInterfaceTable!
    
    var username : String = ""
    
    let endpoint = "http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9441/"
    let baseroot = "idaas/im/v1"
    
    var tasks : [Tasks]!
    
    @IBAction func refreshButton() {
        self.loadTableData()
        approveTable.scrollToRowAtIndex(0)
    }
    
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        let emoji = userInfo["user"] as? String
        self.username = emoji!
        print("user: \(self.username)")
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        /*
        dispatch_async(dispatch_get_main_queue()) {
            if let emoji = emoji {
                print("Last emoji: \(emoji)")
                self.username = emoji
                print("user: \(self.username)")
            }
        }
*/
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        
        //let appGroupID = "group.com.persistent.plat-sol.OIGApp"
        
        //let defaults = NSUserDefaults(suiteName: appGroupID)
        //let username = "dcrane" as String! //defaults?.stringForKey("userLogin")
        
        
        var user = "" as String!
        if self.username == "" {
            user = "dcrane"
        } else {
            user = self.username
        }
        print("user 1: \(user)")
        
        let url2 = endpoint + baseroot + "/users/login"
        let paramstring = "username=" + user + "&password=Oracle123"
        
        LogIn(paramstring, url : url2) { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                //println("Success")
            }
            else {
                //println("Failed")
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(succeeded) {
                    //println("Success Async")
                    self.loadTableData()
                }
            })
        }
    }
    
    private func loadTableData() {
        self.tasks = [Tasks]()
        
        //let appGroupID = "group.com.persistent.plat-sol.OIGApp"
        
        //let defaults = NSUserDefaults(suiteName: appGroupID)
        //print(defaults?.stringForKey("userLogin"))
        //let username = "dcrane" as String! //defaults?.stringForKey("userLogin")
        var user = "" as String!
        if self.username == "" {
            user = "dcrane"
        } else {
            user = self.username
        }
        print("user 2: \(user)")
        let url = endpoint + baseroot + "/users/" + user + "/approvals/"
        loadPendingApprovals(user, apiUrl: url, completion : didLoadData)
       
    }
    
    func didLoadData(loadedData: [Tasks]){
        
        //self.tasks = [Tasks]()
        
        for data in loadedData {
            self.tasks.append(data)
        }
        
        if approveTable.numberOfRows != tasks.count {
            approveTable.setNumberOfRows(tasks.count, withRowType: "ApproveTableRowController")
        }
        
        for (index, info) in tasks.enumerate() {
            //println(index)
            if let row = approveTable.rowControllerAtIndex(index) as? ApproveTableRowController {
                var titleText = ""
                for ent in info.requestEntityName {
                    if titleText.isEmpty {
                        titleText = ent.entityname
                    } else {
                        titleText += " , \(ent.entityname)"
                    }
                }
                
                row.titleLabel.setText(titleText)
                var beneficiaryText = ""
                for ben in info.beneficiaryUser {
                    if beneficiaryText.isEmpty {
                        beneficiaryText = ben.beneficiary
                    } else {
                        beneficiaryText += " , \(ben.beneficiary)"
                    }
                }
                row.subtitleLabel.setText(beneficiaryText)
                row.descriptionLabel.setText(info.requestJustification)
                row.dateLabel.setText(formatDate(info.requestedDate))
            }
        }
        
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if segueIdentifier == "ApproveDetails" {
            let info = tasks[rowIndex]
            return info
        }
        
        return nil
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        approveTable.scrollToRowAtIndex(0)
    }


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadPendingApprovals(loginId: String, apiUrl: String, completion: (([Tasks]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue("TestClient", forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["task"] as! NSArray
                
                var tasks = [Tasks]()
                for task in results{
                    let task = Tasks(data: task as! NSDictionary)
                    tasks.append(task)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(tasks)
                    }
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
        request.addValue("TestClient", forHTTPHeaderField: "clientId")
        
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
    
    func formatDate(dateString: String) -> String {
        
        let formatter = NSDateFormatter()
        //Thu Aug 13 18:19:07 EDT 2015
        formatter.dateFormat = "EEE MMM dd H:mm:ss yyyy" //yyyy-MM-dd'T'HH:mm:ssZ
        let date = formatter.dateFromString(dateString.stringByReplacingOccurrencesOfString("EDT", withString: ""))
        
        formatter.dateFormat = "EEE, MMM dd h:mm a"
        return formatter.stringFromDate(date!)
    }
}



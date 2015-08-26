//
//  InterfaceController.swift
//  OIG WatchKit Extension
//
//  Created by Linh NGUYEN on 8/24/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var approveTable: WKInterfaceTable!
    
    let endpoint = "http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9080/"
    let baseroot = "idaas/oig/v1"
    let myLoginId = "dcrane"
    
    var tasks : [Tasks]!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let url2 = endpoint + baseroot + "/users/login"
        let paramstring = "username=dcrane&password=Oracle123"
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
        let url = endpoint + baseroot + "/users/dcrane/approvals/"
        loadPendingApprovals("dcrane", apiUrl: url, completion : didLoadData)
       
    }
    
    func didLoadData(loadedData: [Tasks]){
        
        //self.tasks = [Tasks]()
        
        for data in loadedData {
            self.tasks.append(data)
        }
        
        //println(self.tasks.count)
        if approveTable.numberOfRows != tasks.count {
            approveTable.setNumberOfRows(tasks.count, withRowType: "ApproveTableRowController")
        }
        
        for (index, info) in enumerate(tasks) {
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
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadPendingApprovals(loginId: String, apiUrl: String, completion: (([Tasks]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
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
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
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
        
        formatter.dateFormat = "EEE, MMM dd"
        return formatter.stringFromDate(date!)
    }
}



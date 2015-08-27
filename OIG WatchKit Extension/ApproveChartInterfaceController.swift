//
//  ApproveChartInterfaceController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 8/25/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import WatchKit
import Foundation


class ApproveChartInterfaceController: WKInterfaceController {

    @IBOutlet weak var group: WKInterfaceGroup!
    let duration = 1.2
    let endpoint = "http://idaasapi.persistent.com:9080/"
    let baseroot = "idaas/oig/v1"
    let myLoginId = "dcrane"
    var myCertificates: Int = 0
    var myApprovals: Int = 0
    var myRequest: Int = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let url2 = endpoint + baseroot + "/users/login"
        let paramstring = "username=dcrane&password=Oracle123"
        LogIn(paramstring, url : url2) { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                let url = self.endpoint + self.baseroot + "/users/dcrane/pendingoperationscount"
                self.getDashboardCount(self.myLoginId, apiUrl: url)
                
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
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
    
    func getDashboardCount(loginId: String, apiUrl: String) {
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
                
                let cntapp: Int = jsonData["count"]!["approvals"] as! Int
                let cntcert: Int = jsonData["count"]!["certifications"] as! Int
                let cntreq: Int = jsonData["count"]!["requests"] as! Int
                
                self.myApprovals = cntapp
                self.myRequest = cntreq
                self.myCertificates = cntcert
                
                
                self.group.setBackgroundImageNamed("singleArc")
                self.group.startAnimatingWithImagesInRange(NSMakeRange(1, cntapp), duration: self.duration, repeatCount: 1)
            }
        })
        
        task.resume()
    }

}

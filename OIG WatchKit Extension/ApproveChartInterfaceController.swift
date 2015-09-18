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
        
        let appGroupID = "group.com.persistent.plat-sol.OIGApp"
        
        let defaults = NSUserDefaults(suiteName: appGroupID)

        let username = defaults?.stringForKey("requestorUserId")
        
        let paramstring = "username=" + username! + "&password=Oracle123"
        LogIn(paramstring, url : url2) { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                let url = self.endpoint + self.baseroot + "/users/" + username! + "/pendingoperationscount"
                self.getDashboardCount(username!, apiUrl: url)
                
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
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue(loginId, forHTTPHeaderField: "loginId")
        
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
    
    func getDashboardCount(loginId: String, apiUrl: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
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

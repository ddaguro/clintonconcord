//
//  ApproveChartInterfaceController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 8/25/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ApproveChartInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var group: WKInterfaceGroup!
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    let duration = 1.2
    let endpoint = "http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9441/"
    let baseroot = "idaas/im/v1"
    
    var myCertificates: Int = 0
    var myApprovals: Int = 0
    var myRequest: Int = 0
    var username : String = ""
    var watchtoken : String = ""
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        let watchuser = userInfo["user"] as? String
        if watchuser != nil {
            self.username = watchuser!
        }
    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        var user = "" as String!
        if self.username == "" {
            user = "dcrane"
        } else {
            user = self.username
        }
        
        //let appGroupID = "group.com.persistent.plat-sol.OIGApp"
        
        //let defaults = NSUserDefaults(suiteName: appGroupID)
        //print(defaults)
        
        //let username = "dcrane" as String?//defaults?.stringForKey("userLogin")
        
        let url2 = endpoint + baseroot + "/users/login"
        let paramstring = "username=" + user! + "&password=Oracle123"
        
        LogIn(paramstring, url : url2) { (succeeded: Bool, msg: String) -> () in
            if(succeeded) {
                let url = self.endpoint + self.baseroot + "/users/" + user! + "/pendingoperationscount"
                self.getDashboardCount(user!, apiUrl: url)
                
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
    
    func getDashboardCount(loginId: String, apiUrl: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue("DevClient", forHTTPHeaderField: "clientId")
        request.addValue(watchtoken, forHTTPHeaderField: "authorization")
        
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
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.group.setBackgroundImageNamed("singleArc")
                    self.group.startAnimatingWithImagesInRange(NSMakeRange(1, cntapp), duration: self.duration, repeatCount: 1)
                })
                
            }
        })
        task.resume()
    }
}

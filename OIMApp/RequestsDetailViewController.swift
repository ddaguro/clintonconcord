//
//  RequestsDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class RequestsDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UIView!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var btnApprove: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var imgView: UIImageView!
    
    var reqs : Requests!
    var api : API!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.labelDescription.textColor = UIColor.whiteColor()
        self.tableView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.tableView.layer.cornerRadius = 5
        self.tableView.layer.shadowOpacity = 0.8
        self.tableView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
        self.imgView.layer.borderColor = UIColor.whiteColor().CGColor
        //self.imgView.layer.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        self.imgView.layer.borderWidth = 1
        self.imgView.layer.cornerRadius = 50
        
        
        
        btnApprove.setTitle("Approve", forState: .Normal)
        btnApprove.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnApprove.titleLabel?.font = UIFont(name: MegaTheme.lighterFontName, size: 16)
        btnApprove.layer.borderWidth = 1
        btnApprove.layer.borderColor = UIColor.whiteColor().CGColor
        btnApprove.layer.cornerRadius = 5
        btnApprove.addTarget(self, action: "Approve", forControlEvents: .TouchUpInside)
        
        btnCancel.setTitle("Cancel", forState: .Normal)
        btnCancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnCancel.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 16)
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        btnCancel.layer.cornerRadius = 5
        btnCancel.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        labelDescription.text = reqs.reqType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Approve(){
        self.api = API()
        
        let url = "http://73.50.120.243:9190/webapp/rest/approvals/performApprovalAction"
        
        let v1 = reqs.reqId as String!
        let v2 = reqs.reqJustification as String!
        let v3 = reqs.reqStatus as String!
        let v4 = reqs.reqType as String!
        
        let paramstring = "{\"requester\": {\"User Login\": \"sdowns\"},\"task\": [{\"requestId\": \"643\",\"taskId\": \"89297ba1-1fb3-4e52-a90a-7e579a98f200\",\"taskNumber\": \"200712\",\"taskPriority\": \"3\",\"taskState\": \"ASSIGNED\",\"taskTitle\": \"Linh Nguyen has submitted a request for approval\",\"taskActionComments\": \"Linh Rejected Using Mobile App\",\"taskAction\": \"REJECT\"}]}"
        
        /*
        {
        "requester": {
        "User Login": "sdowns"
        },
        "task": [
        {
        "requestId": "539",
        "taskId": "0c51c0fe-2257-4050-b7a5-3c8ea05ead99",
        "taskNumber": "200632",
        "taskPriority": "3",
        "taskState": "ASSIGNED",
        "taskTitle": "Ron Platikus has submitted a request for approval",
        "taskActionComments": "Linh Rejected Using Mobile App",
        "taskAction": "REJECT"
        }
        ]
        }
        */
        
        api.RequestApprovalAction(paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
            var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            if(succeeded) {
                alert.title = "Success!"
                alert.message = msg
                
            }
            else {
                alert.title = "Failed : ("
                alert.message = msg
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                alert.show()
            })
        }

    }
    
    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}


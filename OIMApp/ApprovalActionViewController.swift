//
//  ApprovalActionViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class ApprovalActionViewController: UIViewController {
    
    @IBOutlet var tableView: UIView!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var btnApprove: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var textAction: UITextField!
    @IBOutlet var textActionComment: UITextField!
    
    var tasks : Tasks!
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
        
        
        
        btnApprove.setTitle("ACTION", forState: .Normal)
        btnApprove.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnApprove.titleLabel?.font = UIFont(name: MegaTheme.lighterFontName, size: 16)
        btnApprove.layer.borderWidth = 1
        btnApprove.layer.borderColor = UIColor.whiteColor().CGColor
        btnApprove.layer.cornerRadius = 5
        btnApprove.addTarget(self, action: "Approve", forControlEvents: .TouchUpInside)
        
        btnCancel.setTitle("CANCEL", forState: .Normal)
        btnCancel.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnCancel.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 16)
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        btnCancel.layer.cornerRadius = 5
        btnCancel.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        labelDescription.layer
        labelDescription.text = tasks.taskTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Approve(){
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let requestid = tasks.requestId as String!
        let taskid = tasks.taskId as String!
        let tasknumber = tasks.taskNumber as String!
        let taskpriority = tasks.taskPriority as String!
        let taskstate = tasks.taskState as String!
        let tasktitle = tasks.taskTitle as String!
        let taskactioncomments = textActionComment.text as String!
        let taskaction = textAction.text as String!
        
        let url = Persistent.endpoint + "/webapp/rest/approvals/performApprovalAction"
        
        var paramstring = "{\"requester\": {\"User Login\": \""
        paramstring += requestorUserId + "\"},\"task\": [{\"requestId\": \""
        paramstring += requestid + "\",\"taskId\": \""
        paramstring += taskid + "\", \"taskNumber\": \""
        paramstring += tasknumber + "\",\"taskPriority\": \""
        paramstring += taskpriority + "\",\"taskState\": \""
        paramstring += taskstate + "\",\"taskTitle\": \""
        paramstring += tasktitle + "\" ,\"taskActionComments\": \""
        paramstring += taskactioncomments + "\",\"taskAction\": \""
        paramstring += taskaction + "\"}]}"
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
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
    }
    
    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

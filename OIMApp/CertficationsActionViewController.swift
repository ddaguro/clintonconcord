//
//  CertficationsActionViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/29/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertficationsActionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var certId : Int!
    var certTitle : String!
    var certType: String!
    var applicationInstanceId : Int!
    
    var certitemdetail : [CertItemDetail]!
    var api : API!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.clipsToBounds = true
        titleLabel.text = certTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        //tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.certitemdetail = [CertItemDetail]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        //webapp/rest/idaas/oig/v1/certifications/users/dcrane/CertificationLineItemsDetails/22/ApplicationInstance/43
        let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/users/" + requestorUserId + "/CertificationLineItemsDetails/" + "\(certId)/" + certType + "/\(applicationInstanceId)"
        api.loadCertItemDetails(url, completion : didLoadData)
        
    }
    func didLoadData(loadedData: [CertItemDetail]){
        
        for data in loadedData {
            self.certitemdetail.append(data)
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certitemdetail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CertsActionCell") as! CertsActionCell
        
        let info = certitemdetail[indexPath.row]

        cell.certifyButton.tag = indexPath.row
        cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
        cell.certifyButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        
        cell.revokeButton.tag = indexPath.row
        cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
        cell.revokeButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        
        cell.moreButton.tag = indexPath.row
        cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        cell.moreButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        
        for action in info.appAccounts {
            cell.titleLabel.text = action.displayName
            cell.riskLabel.text = "Risk"
            
            var itemRiskImage = UIImage()
            if action.riskSummary == "Low Risk" {
                itemRiskImage = UIImage(named: "risk-low")!
            } else if action.riskSummary == "Medium Risk" {
                itemRiskImage = UIImage(named: "risk-medium")!
            } else if action.riskSummary == "High Risk" {
                itemRiskImage = UIImage(named: "risk-high")!
            }
            cell.riskImage.image = itemRiskImage
            
            cell.riskStatusLabel.text = action.riskSummary
            cell.descriptionLabel.text = action.targetAccountUserLogin
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func buttonAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        
        let task = self.certitemdetail[btnsendtag.tag]
        /*
        var certId : Int!
        var certTitle : String!
        var certType: String!
        var applicationInstanceId : Int!
        
        let requestid = task.requestId as String!
        let taskid = task.taskId as String!
        let tasknumber = task.taskNumber as String!
        let taskpriority = task.taskPriority as String!
        let taskstate = task.taskState as String!
        let tasktitle = task.taskTitle as String!
        let taskactioncomments = "" as String!
        */
        var taskaction : String!
        var alerttitle : String!
        var alertmsg : String!
        
        if action == "Certify" {
            
            taskaction = "CERTIFY"
            alerttitle = "Certify Confirmation"
            alertmsg = "Please confirm approval for " + self.certType
            
        } else if action == "Revoke" {
            
            taskaction = "REVOKE"
            alerttitle = "Revoke Confirmation"
            alertmsg = "Please confirm rejection of " + self.certType
            
        } else if action == "More" {
            
            taskaction = "CLAIM"
            alerttitle = "More Options"
            alertmsg = ""
        }
        
        var alert = UIAlertController(title: alerttitle, message: alertmsg, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as! UITextField
            //PERFORM APPROVAL THRU API
            let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/PerformCertificationAction"
            
            /*
            var paramstring = "{\"requester\": {\"User Login\": \""
            paramstring += requestorUserId + "\"},\"task\": [{\"requestId\": \""
            paramstring += requestid + "\",\"taskId\": \""
            paramstring += taskid + "\", \"taskNumber\": \""
            paramstring += tasknumber + "\",\"taskPriority\": \""
            paramstring += taskpriority + "\",\"taskState\": \""
            paramstring += taskstate + "\",\"taskTitle\": \""
            paramstring += tasktitle + "\" ,\"taskActionComments\": \""
            paramstring += textField.text + "\",\"taskAction\": \""
            paramstring += taskaction + "\"}]}"
            */
            
            
            var jsonstring = "{\"identityCertifications\": {\"certificationLineItemDetails\": [{\"certificationId\": 78,\"entityId\": 142,\"accounts\": [{\"displayName\": \"OUD AI(GDAVIS)\",\"rowEntityId\": \"131\",\"targetAccountUserLogin\": \"GDAVIS\",\"entitlements\": []}]}],\"requesterId\": \"dcrane\",\"certificationType\": \"ApplicationInstance\",\"certificationComments\": \"User need domain account\",\"certificationDecision\": \"CERTIFY\",\"identityPassword\": \"Oracle123\"}}"

            
            self.api.RequestCertificationsAction(jsonstring, url : url) { (succeeded: Bool, msg: String) -> () in
                var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay")
                if(succeeded) {
                    alert.title = "Success!"
                    alert.message = msg
                    
                }
                else {
                    alert.title = "Failed : ("
                    alert.message = msg
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    /*
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewControllerWithIdentifier("ApprovalsViewController") as! ApprovalsViewController
                    controller.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                    self.presentViewController(controller, animated: true, completion: nil)
                    */
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

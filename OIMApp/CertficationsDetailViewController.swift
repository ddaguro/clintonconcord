//
//  CertficationsDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/22/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertficationsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    var certId : Int!
    var certTitle : String!
    var certType: String!
    
    
    var certitem : [CertItem]!
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
        
        self.certitem = [CertItem]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        //webapp/rest/idaas/oig/v1/certifications/users/dcrane/CertificationLineItems/49/ApplicationInstance
        let url = Persistent.endpoint + "webapp/rest/idaas/oig/v1/certifications/users/" + requestorUserId + "/CertificationLineItems/" + "\(certId)/" + certType
        api.loadCertItem(url, completion : didLoadData)
        
    }
    func didLoadData(loadedData: [CertItem]){
        
        for data in loadedData {
            self.certitem.append(data)
        }
        self.tableView.reloadData()
    }
    
    func didLoadDetailData(loadedData: [CertItemDetail]){
        
        for data in loadedData {
            self.certitemdetail.append(data)
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certitem.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CertsDetailCell") as! CertsDetailCell
        
        let info = certitem[indexPath.row]
        /*
        self.certitemdetail = [CertItemDetail]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        //webapp/rest/idaas/oig/v1/certifications/users/dcrane/CertificationLineItemsDetails/22/ApplicationInstance/43
        let url = Persistent.endpoint + "webapp/rest/idaas/oig/v1/certifications/users/" + requestorUserId + "/CertificationLineItemsDetails/" + "\(certId)/" + certType + "/\(info.applicationInstanceId)"
        api.loadCertItemDetails(url, completion : didLoadDetailData)
        
        //let detail = certitemdetail[0]
        
        */
        cell.certifyButton.tag = indexPath.row
        cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
        cell.certifyButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        
        
        cell.revokeButton.tag = indexPath.row
        cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
        cell.revokeButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        
        cell.moreButton.tag = indexPath.row
        cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        cell.moreButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        
        cell.titleLabel.text = info.applicationInstanceName
        cell.riskLabel.text = "Risk"
        cell.riskImage.image = info.itemRisk == "Low Risk" ? UIImage(named: "risk-low") : UIImage(named: "risk-medium")
        cell.riskStatusLabel.text = info.itemRisk
        cell.descriptionLabel.text = info.resourceType + " " //+ detail.displayName
        cell.progressLabel.text = "Progress"
        cell.progressImage.image = info.percentComplete == 0 ? UIImage(named: "percent0") : UIImage(named: "percent100")
        cell.percentLabel.text = "\(info.percentComplete)"
        
        return cell
    }
    
    func buttonAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        
        /*
        let task = self.tasks[btnsendtag.tag]
        
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

        
        if action == "Approve" {
            
            taskaction = "APPROVE"
            alerttitle = "Approval Confirmation"
            alertmsg = "Please confirm approval for "
            
        } else if action == "Decline" {
            
            taskaction = "REJECT"
            alerttitle = "Decline Confirmation"
            alertmsg = "Please confirm rejection of "
            
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
            let url = Persistent.endpoint + "/webapp/rest/approvals/performApprovalAction"
            
            var paramstring = "{\"requester\": {\"User Login\": \""
            paramstring += requestorUserId + "\"},\"task\": [{\"requestId\": \""
            //paramstring += requestid + "\",\"taskId\": \""
            //paramstring += taskid + "\", \"taskNumber\": \""
            //paramstring += tasknumber + "\",\"taskPriority\": \""
            //paramstring += taskpriority + "\",\"taskState\": \""
            //paramstring += taskstate + "\",\"taskTitle\": \""
            //paramstring += tasktitle + "\" ,\"taskActionComments\": \""
            paramstring += textField.text + "\",\"taskAction\": \""
            paramstring += taskaction + "\"}]}"
            
            self.api.RequestApprovalAction(paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
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
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewControllerWithIdentifier("CertficationsViewController") as! CertficationsViewController
                    controller.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}

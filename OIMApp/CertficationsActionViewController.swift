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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    
    var certId : Int!
    var certTitle : String!
    var certType: String!
    var applicationInstanceId : Int!
    var entitlementId : Int!
    
    var certitemdetail : [CertItemDetail]!
    var certentitemdetail : [EntitlementItemDetail]!
    var api : API!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.clipsToBounds = true
        titleLabel.text = certTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        self.certitemdetail = [CertItemDetail]()
        self.certentitemdetail = [EntitlementItemDetail]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        //webapp/rest/idaas/oig/v1/certifications/users/dcrane/CertificationLineItemsDetails/22/ApplicationInstance/43
        
        var certdetailid : Int!
        if certType == "ApplicationInstance" {
            certdetailid = applicationInstanceId
        } else if certType == "Entitlement" {
            certdetailid = entitlementId
        }
        
        let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/users/" + requestorUserId + "/CertificationLineItemsDetails/" + "\(certId)/" + certType + "/\(certdetailid)"
        
        if certType == "ApplicationInstance" {
            api.loadCertItemDetails(url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadCertEntItemDetails(url, completion : didLoadEntDetailData)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        //---> Adding Swipe Gesture
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    // MARK: swipe gestures
    func rightSwiped()
    {
        println("right swiped ")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func leftSwiped()
    {
        println("left swiped ")
    }
    
    func didLoadData(loadedData: [CertItemDetail]){
        self.certitemdetail = [CertItemDetail]()
        for data in loadedData {
            self.certitemdetail.append(data)
        }
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    func didLoadEntDetailData(loadedData: [EntitlementItemDetail]){
        self.certentitemdetail = [EntitlementItemDetail]()
        for data in loadedData {
            self.certentitemdetail.append(data)
        }
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func refresh(){
        var certdetailid : Int!
        if certType == "ApplicationInstance" {
            certdetailid = applicationInstanceId
        } else if certType == "Entitlement" {
            certdetailid = entitlementId
        }
        let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/users/" + myRequestorId + "/CertificationLineItemsDetails/" + "\(certId)/" + certType + "/\(certdetailid)"
        
        if certType == "ApplicationInstance" {
            api.loadCertItemDetails(url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadCertEntItemDetails(url, completion : didLoadEntDetailData)
        }
        
        SoundPlayer.play("upvote.wav")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int!
        
        if certType == "ApplicationInstance" {
            count = certitemdetail.count
        } else if certType == "Entitlement" {
            count = certentitemdetail.count
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CertsActionCell") as! CertsActionCell
        
        
        if certType == "ApplicationInstance" {
            let info = certitemdetail[indexPath.row]
            
            if (info.lastCertificationActionDetails.rangeOfString("Action : Certify Taken By") == nil) {
                cell.certifyButton.tag = indexPath.row
                cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
                cell.certifyButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
                
                cell.revokeButton.tag = indexPath.row
                cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
                cell.revokeButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
                
                cell.moreButton.tag = indexPath.row
                cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
                cell.moreButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
            } else {
                cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certified"), forState: .Normal)
                cell.revokeButton.hidden = true
                cell.moreButton.hidden = true
            }
            

            
            cell.titleLabel.text = info.displayName
            cell.riskLabel.text = "Risk"
            
            var itemRiskImage = UIImage()
            if info.riskSummary == "Low Risk" {
                itemRiskImage = UIImage(named: "risk-low")!
            } else if info.riskSummary == "Medium Risk" {
                itemRiskImage = UIImage(named: "risk-medium")!
            } else if info.riskSummary == "High Risk" {
                itemRiskImage = UIImage(named: "risk-high")!
            }
            cell.riskImage.image = itemRiskImage
            
            cell.riskStatusLabel.text = info.riskSummary
            
            var text = ""
            for ent in info.certacctentitlements {
                if text.isEmpty {
                    text = ent.entitlementDisplayName
                } else {
                    text += " , \(ent.entitlementDisplayName)"
                }
            }
            
            
            cell.descriptionLabel.text = "Entitlements: " + text
        } else if certType == "Entitlement" {
            let info = certentitemdetail[indexPath.row]
            
            cell.certifyButton.tag = indexPath.row
            cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
            cell.certifyButton.addTarget(self, action: "buttonEntAction:", forControlEvents: .TouchUpInside)
            
            cell.revokeButton.tag = indexPath.row
            cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
            cell.revokeButton.addTarget(self, action: "buttonEntAction:", forControlEvents: .TouchUpInside)
            
            cell.moreButton.tag = indexPath.row
            cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
            cell.moreButton.addTarget(self, action: "buttonEntAction:", forControlEvents: .TouchUpInside)
            
            cell.titleLabel.text = info.firstName + " " + info.lastName
            cell.riskLabel.text = "Risk"
                
            var itemRiskImage = UIImage()
            if info.riskSummary == "Low Risk" {
                itemRiskImage = UIImage(named: "risk-low")!
            } else if info.riskSummary == "Medium Risk" {
                itemRiskImage = UIImage(named: "risk-medium")!
            } else if info.riskSummary == "High Risk" {
                itemRiskImage = UIImage(named: "risk-high")!
            }
            cell.riskImage.image = itemRiskImage
                
            cell.riskStatusLabel.text = info.riskSummary
            cell.descriptionLabel.text = info.accountName
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
        
        let cert = self.certitemdetail[btnsendtag.tag]
        
        let cid = certId //cert.certificationId as Int!
        let entityid = entitlementId //cert.entityId as Int!
        
        var displayname : String!
        var rowentityid : String!
        var targetuser : String!
        var risksummary : String!
        
        displayname = cert.displayName
        rowentityid = cert.rowEntityId
        targetuser = cert.targetAccountUserLogin
        risksummary = cert.riskSummary
        /*
        for account in cert.appAccounts {
        displayname = account.displayName
        rowentityid = account.rowEntityId
        targetuser = account.targetAccountUserLogin
        risksummary = account.riskSummary
        }
        */
        
        let ctitle = self.certTitle
        let ctype = self.certType
        let certactioncomments = "" as String!

        var certaction : String!
        var alerttitle : String!
        var alertmsg : String!
        
        if action == "Certify" {
            
            certaction = "CERTIFY"
            alerttitle = "Certify Confirmation"
            alertmsg = "Please confirm approval for " + self.certType
            
        } else if action == "Revoke" {
            
            certaction = "REVOKE"
            alerttitle = "Revoke Confirmation"
            alertmsg = "Please confirm rejection of " + self.certType
            
        } else if action == "More" {
            
            certaction = ""
            alerttitle = ""
            alertmsg = ""
        }
        
        var doalert : DOAlertController
        
        if action != "More" {
            
            doalert = DOAlertController(title: alerttitle, message: alertmsg, preferredStyle: .Alert)
            
            // Add the text field for text entry.
            doalert.addTextFieldWithConfigurationHandler { textField in
                // If you need to customize the text field, you can do so here.
            }
            let certifyAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
                //PERFORM APPROVAL THRU API
                let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/PerformCertificationAction"
                
                var jsonstring = "{\"identityCertifications\": {\"certificationLineItemDetails\": [{\"certificationId\": " + "\(cid)"
                jsonstring += ",\"entityId\": " +  "\(self.applicationInstanceId)"
                jsonstring += ",\"accounts\": [{\"displayName\": \"" + displayname
                jsonstring += "\",\"rowEntityId\": \"" + rowentityid
                jsonstring += "\",\"targetAccountUserLogin\": \"" + targetuser
                jsonstring += "\",\"entitlements\": []}]}],"
                jsonstring += "\"requesterId\": \"" + requestorUserId
                jsonstring += "\",\"certificationType\": \"" + ctype
                jsonstring += "\",\"certificationComments\": \"" + textField.text
                jsonstring += "\",\"certificationDecision\": \"" + "CERTIFY"
                jsonstring += "\",\"identityPassword\": \"" + "Oracle123"
                jsonstring += "\"}}"
                
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
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    })
                }
            }
            let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            doalert.addAction(cancelAction)
            doalert.addAction(certifyAction)
            
            presentViewController(doalert, animated: true, completion: nil)
        } else {
            doalert = DOAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let certifyAction = DOAlertAction(title: "Certify", style: .Destructive) { action in
            }
            let abstainAction = DOAlertAction(title: "Abstain", style: .Destructive) { action in
            }
            let revokeAction = DOAlertAction(title: "Revoke", style: .Destructive) { action in
            }
            let conditionallyAction = DOAlertAction(title: "Certify Conditonally", style: .Destructive) { action in
            }
            let signoffAction = DOAlertAction(title: "Sign-off", style: .Destructive) { action in
            }
            let resetAction = DOAlertAction(title: "Reset Status", style: .Destructive) { action in
            }
            let editAction = DOAlertAction(title: "Edit Comment", style: .Destructive) { action in
            }
            let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            // Add the action.
            doalert.addAction(certifyAction)
            doalert.addAction(abstainAction)
            doalert.addAction(revokeAction)
            doalert.addAction(conditionallyAction)
            doalert.addAction(signoffAction)
            doalert.addAction(resetAction)
            doalert.addAction(editAction)
            doalert.addAction(cancelAction)
            
            presentViewController(doalert, animated: true, completion: nil)
        }
    }
    
    func buttonEntAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        
        let certent = self.certentitemdetail[btnsendtag.tag]
        
        let cid = certent.certificationId as Int!
        let entityid = certent.entityId as Int!
        
        var displayname : String!
        var rowentityid : String!
        var targetuser : String!
        var risksummary : String!
        
        displayname = certent.firstName + " " + certent.lastName
        risksummary = certent.riskSummary
        
        let ctitle = self.certTitle
        let ctype = self.certType
        let certactioncomments = "" as String!
        
        var certaction : String!
        var alerttitle : String!
        var alertmsg : String!
        
        if action == "Certify" {
            
            certaction = "CERTIFY"
            alerttitle = "Certify Confirmation"
            alertmsg = "Please confirm approval for " + displayname
            
        } else if action == "Revoke" {
            
            certaction = "REVOKE"
            alerttitle = "Revoke Confirmation"
            alertmsg = "Please confirm rejection of " + displayname
            
        } else if action == "More" {
            
            certaction = ""
            alerttitle = ""
            alertmsg = ""
        }
        
        var doalert : DOAlertController
        
        if action != "More" {
            
            doalert = DOAlertController(title: alerttitle, message: alertmsg, preferredStyle: .Alert)
            
            doalert.addTextFieldWithConfigurationHandler { textField in
            }
            let certifyAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
            }
            let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            doalert.addAction(cancelAction)
            doalert.addAction(certifyAction)
            
            presentViewController(doalert, animated: true, completion: nil)
        } else {
            doalert = DOAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let certifyAction = DOAlertAction(title: "Certify", style: .Destructive) { action in
            }
            let abstainAction = DOAlertAction(title: "Abstain", style: .Destructive) { action in
            }
            let revokeAction = DOAlertAction(title: "Revoke", style: .Destructive) { action in
            }
            let conditionallyAction = DOAlertAction(title: "Certify Conditonally", style: .Destructive) { action in
            }
            let signoffAction = DOAlertAction(title: "Sign-off", style: .Destructive) { action in
            }
            let resetAction = DOAlertAction(title: "Reset Status", style: .Destructive) { action in
            }
            let editAction = DOAlertAction(title: "Edit Comment", style: .Destructive) { action in
            }
            let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            // Add the action.
            doalert.addAction(certifyAction)
            doalert.addAction(abstainAction)
            doalert.addAction(revokeAction)
            doalert.addAction(conditionallyAction)
            doalert.addAction(signoffAction)
            doalert.addAction(resetAction)
            doalert.addAction(editAction)
            doalert.addAction(cancelAction)
            
            presentViewController(doalert, animated: true, completion: nil)
        }
    }

}

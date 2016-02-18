//
//  CertficationsActionViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/29/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertficationsActionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBOutlet var btnEdit: UIBarButtonItem!
    @IBOutlet var btnSelectedEdit: UIBarButtonItem!
    @IBOutlet var btnEditRevoke: UIBarButtonItem!
    
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    
    var certId : Int!
    var certTitle : String!
    var certType: String!
    
    var applicationInstanceId : Int!
    var entitlementId : Int!
    var userId : Int!
    var roleentityId : Int!
    
    var certitemdetail : [CertItemDetail]!
    var selectedcertitem : [CertItemDetail] = []
    
    var certentitemdetail : [EntitlementItemDetail]!
    var selectedcertentitem : [EntitlementItemDetail] = []
    
    var certuseritemdetail : [UserItemDetail]!
    var selectedcertuseritem : [UserItemDetail] = []
    
    var certroleitemdetail : [RoleItemDetail]!
    var selectedcertroleitem : [RoleItemDetail] = []
    
    var api : API!
    
    @IBAction func btnEditAction(sender: AnyObject) {
        if tableView.editing {
            self.tableView.setEditing(false, animated: true)
            btnEdit.title = "Edit"
            btnSelectedEdit.image = UIImage()
            btnSelectedEdit.enabled = false
            btnEditRevoke.title = ""
            btnEditRevoke.enabled = false
        } else {
            self.tableView.setEditing(true, animated: true)
            btnEdit.title = "Cancel"
            btnSelectedEdit.image = UIImage(named:"toolbar-certify")
            btnSelectedEdit.enabled = true
            btnEditRevoke.title = ""
            btnEditRevoke.enabled = false
        }
        self.tableView.reloadData()
    }
    
    @IBAction func btnEditCertifyAction(sender: AnyObject) {
        if certType == "ApplicationInstance" {
            if self.selectedcertitem.count > 0 {
                var doalert : DOAlertController
                doalert = DOAlertController(title: "Certification Confirmation", message: "Please confirm certifications for the selected record(s)", preferredStyle: .Alert)
                
                doalert.addTextFieldWithConfigurationHandler { textField in
                    textField.placeholder = " Enter Comments "
                }
                
                let approveAction = DOAlertAction(title: "OK", style: .Default) { action in
                    
                    let textField = doalert.textFields![0] as! UITextField
                    
                    var certaction = "CERTIFY" as String!
                    let url = myAPIEndpoint + "/certifications"
                    
                    var jsonstring = "{\"identityCertifications\": {\"certificationId\": " + "\(self.certId)"
                    jsonstring += ",\"entityId\": " +  "\(self.applicationInstanceId)"
                    jsonstring += ",\"requesterId\": \"" + myLoginId
                    jsonstring += "\",\"certificationType\": \"" + self.certType
                    jsonstring += "\",\"certificationComments\": \"" + textField.text!
                    jsonstring += "\",\"certificationDecision\": \"" + "CERTIFY"
                    jsonstring += "\",\"identityPassword\": \"" + "Oracle123" + "\""
                    jsonstring += ",\"accounts\": ["
                    
                    for var i = 0; i < self.selectedcertitem.count; ++i {
                        let cert = self.selectedcertitem[i]
                        jsonstring += "{\"displayName\": \"" + cert.displayName
                        jsonstring += "\",\"rowEntityId\": \"" + cert.rowEntityId
                        jsonstring += "\",\"targetAccountUserLogin\": \"" + cert.targetAccountUserLogin
                        jsonstring += "\",\"entitlements\": []},"
                    }
                    jsonstring += "]}"
                    
                    var idx = jsonstring.endIndex.advancedBy(-3)
                    
                    var substring1 = jsonstring.substringToIndex(idx)
                    substring1 += "]}}"
                    //println(substring1)
                    
                    self.api.RequestCertificationsAction(myLoginId, params : substring1, url : url) { (succeeded: Bool, msg: String) -> () in
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
                            self.view.showLoading()
                            self.refresh()
                            
                            self.tableView.setEditing(false, animated: true)
                            self.btnEdit.title = "Edit"
                            self.btnSelectedEdit.image = UIImage()
                            self.btnSelectedEdit.enabled = false
                            self.tableView.reloadData()
                            
                        })
                    }
                }
                let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
                }
                doalert.addAction(cancelAction)
                doalert.addAction(approveAction)
                
                presentViewController(doalert, animated: true, completion: nil)
            } else {
                var alert = UIAlertView(title: "Error : (", message: "You must select at least one", delegate: nil, cancelButtonTitle: "Okay")
                alert.show()
            }
        } else if certType == "Entitlement" {
            if self.selectedcertentitem.count > 0 {
                var doalert : DOAlertController

                doalert = DOAlertController(title: "Certification Confirmation", message: "Please confirm certifications for the selected record(s)", preferredStyle: .Alert)
                
                doalert.addTextFieldWithConfigurationHandler { textField in
                    textField.placeholder = " Enter Comments "
                }
                let certifyAction = DOAlertAction(title: "OK", style: .Default) { action in
                    let textField = doalert.textFields![0] as! UITextField
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    })
                }
                let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
                }
                doalert.addAction(cancelAction)
                doalert.addAction(certifyAction)
                
                presentViewController(doalert, animated: true, completion: nil)
            } else {
                var alert = UIAlertView(title: "Error : (", message: "You must select at least one", delegate: nil, cancelButtonTitle: "Okay")
                alert.show()
            }

        }
    }
    
    @IBAction func btnEditRevokeAction(sender: AnyObject) {
        let alert = UIAlertView(title: "Alert", message: "Revoke", delegate: nil, cancelButtonTitle: "Okay")
        alert.show()
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.clipsToBounds = true
        titleLabel.text = certTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
        
        btnSelectedEdit.enabled = false
        btnEditRevoke.enabled = false
        
        self.certitemdetail = [CertItemDetail]()
        self.certentitemdetail = [EntitlementItemDetail]()
        self.certuseritemdetail = [UserItemDetail]()
        self.certroleitemdetail = [RoleItemDetail]()
        
        self.api = API()
        
        var certdetailid : Int!
        if certType == "ApplicationInstance" {
            certdetailid = applicationInstanceId
        } else if certType == "Entitlement" {
            certdetailid = entitlementId
        } else if certType == "User" {
            certdetailid = userId
        } else if certType == "Role" {
            certdetailid = roleentityId
        }
        
        var roletype : String! = ""
        if certType == "Role" {
            roletype = "/members"
        }
        
        let url = myAPIEndpoint + "/certifications/certificationlineitemdetails/" + "\(certId)/" + certType + "/\(certdetailid)" + roletype
        
        if certType == "ApplicationInstance" {
            api.loadCertItemDetails(myLoginId, apiUrl : url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadCertEntItemDetails(myLoginId, apiUrl: url, completion : didLoadEntDetailData)
        } else if certType == "User" {
            api.loadCertUserItemDetails(myLoginId, apiUrl: url, completion : didLoadUserDetailData)
        } else if certType == "Role" {
            api.loadCertRoleItemDetails(myLoginId, apiUrl: url, completion : didLoadRoleDetailData)
        }
        
        //refreshControl = UIRefreshControl()
        //refreshControl.tintColor = UIColor.redColor()
        //refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        //tableView.addSubview(refreshControl)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
        
    }
    
    func refresh(){
        var certdetailid : Int!
        if certType == "ApplicationInstance" {
            certdetailid = applicationInstanceId
        } else if certType == "Entitlement" {
            certdetailid = entitlementId
        }
        let url = myAPIEndpoint + "/certifications/certificationlineitemdetails/" + "\(certId)/" + certType + "/\(certdetailid)"
        
        if certType == "ApplicationInstance" {
            api.loadCertItemDetails(myLoginId, apiUrl : url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadCertEntItemDetails(myLoginId, apiUrl: url, completion : didLoadEntDetailData)
        } else if certType == "User" {
            api.loadCertUserItemDetails(myLoginId, apiUrl: url, completion : didLoadUserDetailData)
        } else if certType == "Role" {
            api.loadCertRoleItemDetails(myLoginId, apiUrl: url, completion : didLoadRoleDetailData)
        }
        
        SoundPlayer.play("upvote.wav")
    }
    
    func didLoadData(loadedData: [CertItemDetail]){
        self.certitemdetail = [CertItemDetail]()
        for data in loadedData {
            self.certitemdetail.append(data)
        }
        if isFirstTime  {
            self.view.showLoading()
        }
        
        self.certitemdetail.sortInPlace({ $0.lastCertificationActionDetails < $1.lastCertificationActionDetails })
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
    
    func didLoadUserDetailData(loadedData: [UserItemDetail]){
        self.certuseritemdetail = [UserItemDetail]()
        for data in loadedData {
            self.certuseritemdetail.append(data)
        }
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    func didLoadRoleDetailData(loadedData: [RoleItemDetail]){
        self.certroleitemdetail = [RoleItemDetail]()
        for data in loadedData {
            self.certroleitemdetail.append(data)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int!
        
        if certType == "ApplicationInstance" {
            count = certitemdetail.count
        } else if certType == "Entitlement" {
            count = certentitemdetail.count
        } else if certType == "User" {
            count = certuseritemdetail.count
        } else if certType == "Role" {
            count = certroleitemdetail.count
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CertsActionCell") as! CertsActionCell
        
        if certType == "ApplicationInstance" {
            let info = certitemdetail[indexPath.row]
            if (info.lastCertificationActionDetails != "") {
                cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certified"), forState: .Normal)
                cell.revokeButton.hidden = true
                cell.moreButton.hidden = true
                if self.tableView.editing {
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                } else {
                    cell.selectionStyle = UITableViewCellSelectionStyle.Default
                }
            } else {
                cell.certifyButton.tag = indexPath.row
                cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
                cell.certifyButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
                
                cell.revokeButton.tag = indexPath.row
                cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
                cell.revokeButton.hidden = false
                cell.revokeButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
                
                cell.moreButton.tag = indexPath.row
                cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
                cell.moreButton.hidden = false
                cell.moreButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
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
        }  else if certType == "User" {
            let info = certuseritemdetail[indexPath.row]
            
            cell.certifyButton.tag = indexPath.row
            cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
            cell.certifyButton.addTarget(self, action: "buttonOtherAction:", forControlEvents: .TouchUpInside)
            
            cell.revokeButton.tag = indexPath.row
            cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
            cell.revokeButton.addTarget(self, action: "buttonOtherAction:", forControlEvents: .TouchUpInside)
            
            cell.moreButton.tag = indexPath.row
            cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
            cell.moreButton.addTarget(self, action: "buttonOtherAction:", forControlEvents: .TouchUpInside)
            
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
            cell.descriptionLabel.text = ""
        }  else if certType == "Role" {
            let info = certroleitemdetail[indexPath.row]
            
            cell.certifyButton.tag = indexPath.row
            cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
            cell.certifyButton.addTarget(self, action: "buttonOtherAction:", forControlEvents: .TouchUpInside)
            
            cell.revokeButton.tag = indexPath.row
            cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
            cell.revokeButton.addTarget(self, action: "buttonOtherAction:", forControlEvents: .TouchUpInside)
            
            cell.moreButton.tag = indexPath.row
            cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
            cell.moreButton.addTarget(self, action: "buttonOtherAction:", forControlEvents: .TouchUpInside)
            
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
            cell.descriptionLabel.text = ""
        }
        
        if self.tableView.editing {
            cell.certifyButton.enabled = false
            cell.revokeButton.enabled = false
            cell.moreButton.enabled = false
            cell.moreButton.hidden = true
        } else {
            cell.certifyButton.enabled = true
            cell.revokeButton.enabled = true
            cell.moreButton.enabled = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let indexPath = self.tableView.indexPathsForSelectedRows as? [NSIndexPath]! {
            
            if certType == "ApplicationInstance" {
                self.selectedcertitem.removeAll(keepCapacity: true)
                for idx in indexPath {
                    let info = certitemdetail[idx.item]
                    self.selectedcertitem.append(info)
                }
            } else if certType == "Entitlement" {
                self.selectedcertentitem.removeAll(keepCapacity: true)
                for idx in indexPath {
                    let info = certentitemdetail[idx.item]
                    self.selectedcertentitem.append(info)
                }
            }
            

        }
    }
    
    func buttonAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
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
            alerttitle = "Certification Confirmation"
            alertmsg = "Please confirm certification for " + cert.displayName
            
        } else if action == "Revoke" {
            
            certaction = "REVOKE"
            alerttitle = "Certification Revoke Confirmation"
            alertmsg = "Please confirm certification revoke for " + cert.displayName
            
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
                textField.placeholder = " Enter Comments "
            }
            let certifyAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
                //PERFORM APPROVAL THRU API
                let url = myAPIEndpoint + "/certifications"
                
                var jsonstring = "{\"identityCertifications\": {\"certificationId\": " + "\(cid)"
                jsonstring += ",\"entityId\": " +  "\(self.applicationInstanceId)"
                jsonstring += ",\"accounts\": [{\"displayName\": \"" + displayname
                jsonstring += "\",\"rowEntityId\": \"" + rowentityid
                jsonstring += "\",\"targetAccountUserLogin\": \"" + targetuser
                jsonstring += "\",\"entitlements\": []}],"
                jsonstring += "\"requesterId\": \"" + myLoginId
                jsonstring += "\",\"certificationType\": \"" + ctype
                jsonstring += "\",\"certificationComments\": \"" + textField.text!
                jsonstring += "\",\"certificationDecision\": \"" + "CERTIFY"
                jsonstring += "\",\"identityPassword\": \"" + "Oracle123"
                jsonstring += "\"}}"
                
                self.api.RequestCertificationsAction(myLoginId, params : jsonstring, url : url) { (succeeded: Bool, msg: String) -> () in
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
                        self.view.showLoading()
                        self.refresh()
                        
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
        let btnsendtag:UIButton = sender
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
            alerttitle = "Certification Confirmation"
            alertmsg = "Please confirm certification for " + displayname
            
        } else if action == "Revoke" {
            
            certaction = "REVOKE"
            alerttitle = "Certification Revoke Confirmation"
            alertmsg = "Please confirm certification revoke for " + displayname
            
        } else if action == "More" {
            
            certaction = ""
            alerttitle = ""
            alertmsg = ""
        }
        
        var doalert : DOAlertController
        
        if action != "More" {
            
            doalert = DOAlertController(title: alerttitle, message: alertmsg, preferredStyle: .Alert)
            
            doalert.addTextFieldWithConfigurationHandler { textField in
                textField.placeholder = " Enter Comments "
            }
            let certifyAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    
                })
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
    
    func buttonOtherAction(sender:UIButton!)
    {
        var certaction : String!
        var alerttitle : String!
        var alertmsg : String!
        
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
        if certType == "User" {
            
        } else if certType == "Role" {
            
        }

        if action == "Certify" {
            
            certaction = "CERTIFY"
            alerttitle = "Certification Confirmation"
            alertmsg = "Please confirm certification"
            
        } else if action == "Revoke" {
            
            certaction = "REVOKE"
            alerttitle = "Certification Revoke Confirmation"
            alertmsg = "Please confirm certification revoke"
            
        } else if action == "More" {
            
            certaction = ""
            alerttitle = ""
            alertmsg = ""
        }
        
        var doalert : DOAlertController
        
        if action != "More" {
            
            doalert = DOAlertController(title: alerttitle, message: alertmsg, preferredStyle: .Alert)
            
            doalert.addTextFieldWithConfigurationHandler { textField in
                textField.placeholder = " Enter Comments "
            }
            let certifyAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    
                })
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

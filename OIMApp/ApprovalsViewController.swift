//
//  MyApprovalsViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/12/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit


class ApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView : UITableView!
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var toolbar : UIToolbar!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var lblTotalCounter: UILabel!
    
    @IBOutlet var btnEdit: UIBarButtonItem!
    @IBOutlet var btnEditDecline: UIBarButtonItem!
    @IBOutlet var btnEditLabel: UIBarButtonItem!
    
    var imageAsync : UIImage!
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    var itemHeading: NSMutableArray! = NSMutableArray()
    var nagivationStyleToPresent : String?
    
    let transitionOperator = TransitionOperator()
    var tasks : [Tasks]!
    var selectedtasks : [Tasks] = []
    var api : API!
    
    @IBAction func btnEditCeclineAction(sender: AnyObject) {
        
        let alert = UIAlertView(title: "Decline Confirmation", message: "Bulk Decline", delegate: nil, cancelButtonTitle: "Okay")
        alert.show()
    }
    
    @IBAction func btnEditAction(sender: AnyObject) {
        //println("Bulk Action")
        //if self.tableView.editing {
        if self.selectedtasks.count > 0 {
            //println("APPROVE")
            var doalert : DOAlertController
            doalert = DOAlertController(title: "Approval Confirmation", message: "Please confirm approval for the selected request(s)", preferredStyle: .Alert)
            
            // Add the text field for text entry.
            doalert.addTextFieldWithConfigurationHandler { textField in
                // If you need to customize the text field, you can do so here.
                textField.placeholder = " Enter Comments "
            }
            
            let approveAction = DOAlertAction(title: "OK", style: .Default) { action in
                
                let textField = doalert.textFields![0] as! UITextField
                
                let url = myAPIEndpoint + "/approvals"
                
                var taskaction = "APPROVE" as String!
                
                var paramstring = "{\"requester\": {\"User Login\": \"" + myLoginId + "\"},\"task\": ["
                
                for var i = 0; i < self.selectedtasks.count; ++i {
                    let task = self.selectedtasks[i]
                    paramstring += "{\"requestId\": \""
                    paramstring += task.requestId + "\",\"taskId\": \""
                    paramstring += task.taskId + "\", \"taskNumber\": \""
                    paramstring += task.taskNumber + "\",\"taskPriority\": \""
                    paramstring += task.taskPriority + "\",\"taskState\": \""
                    paramstring += task.taskState + "\",\"taskTitle\": \""
                    paramstring += task.taskTitle + "\" ,\"taskActionComments\": \""
                    paramstring += textField.text! + "\",\"taskAction\": \""
                    paramstring += taskaction + "\"},"
                }
                paramstring += "]}"
                
                
                var idx = paramstring.endIndex.advancedBy(-3)
                
                var substring1 = paramstring.substringToIndex(idx)
                substring1 += "]}"
                //println(substring1)
                
                self.api.RequestApprovalAction(myLoginId, params : substring1, url : url) { (succeeded: Bool, msg: String) -> () in
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
                        self.btnEditLabel.title = "Edit"
                        self.btnEdit.image = UIImage()
                        self.btnEdit.enabled = false
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
    }
    
    @IBAction func btnEdit(sender: AnyObject) {
        //self.editing = !self.editing
        
        if tableView.editing {
            self.tableView.setEditing(false, animated: true)
            btnEditLabel.title = "Edit"
            btnEdit.title = ""
            btnEditDecline.title = ""
            btnEdit.image = UIImage()
            btnEdit.enabled = false
            btnEditDecline.enabled = false
            
        } else {
            self.tableView.setEditing(true, animated: true)
            btnEditLabel.title = "Cancel"
            btnEdit.image = UIImage(named:"toolbar-approve")
            btnEditDecline.title = ""
            btnEdit.enabled = true
            btnEditDecline.enabled = false
        }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (totalCounter > 0) {
            self.lblTotalCounter.hidden = false
            self.lblTotalCounter.layer.cornerRadius = 9;
            lblTotalCounter.layer.masksToBounds = true;
            self.lblTotalCounter.text = "\(totalCounter)"
        } else {
            self.lblTotalCounter.hidden = true
        }
        
        toolbar.clipsToBounds = true
        
        labelTitle.text = "Pending Approvals"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        tableView.allowsMultipleSelectionDuringEditing = true
        //tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = true
        //tableView.estimatedRowHeight = 300
        //tableView.rowHeight = UITableViewAutomaticDimension
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        btnEdit.enabled = false
        btnEditDecline.enabled = false
        
        itemHeading.addObject("Approvals")
        
        self.tasks = [Tasks]()
        self.api = API()
        
        let url = myAPIEndpoint + "/users/" + myLoginId + "/approvals/"
        api.loadPendingApprovals(myLoginId, apiUrl: url, completion : didLoadData)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        //---> PanGestureRecognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        self.view.addGestureRecognizer(recognizer)
        
        /*
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Approve"
        localNotification.alertBody = "Kevin Clark is requesting West Data Center Access."
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = 1
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 15)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        */

        
    }
    
    // MARK: swipe gestures
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.panGestureRecognized(sender)
    }

    func refresh(){
        let url = myAPIEndpoint + "/users/" + myLoginId + "/approvals/"
        api.loadPendingApprovals(myLoginId, apiUrl: url, completion : didLoadData)
        
        SoundPlayer.play("upvote.wav")
    }
    
    func didLoadData(loadedData: [Tasks]){
        
        self.tasks = [Tasks]()
        
        for data in loadedData {
            self.tasks.append(data)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tasks == nil
        {
            return 0
        }
        return self.tasks!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TasksCell") as! TasksCell
        
        
        cell.approveBtn.tag = indexPath.row
        cell.approveBtn.setBackgroundImage(UIImage(named:"btn-approve"), forState: .Normal)
        cell.approveBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        
        cell.declineBtn.tag = indexPath.row
        cell.declineBtn.setBackgroundImage(UIImage(named:"btn-decline"), forState: .Normal)
        cell.declineBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        
        cell.moreBtn.tag = indexPath.row
        cell.moreBtn.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        cell.moreBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)

        var titleText = ""
        for ent in task.requestEntityName {
            if titleText.isEmpty {
                titleText = ent.entityname
            } else {
                titleText += " , \(ent.entityname)"
            }
        }
        cell.nameLabel.text = titleText
        cell.postLabel?.text = task.requestType
        cell.beneficiaryLabel.text = "Beneficiaries"
        
        var beneficiaryText = ""
        for ben in task.beneficiaryUser {
            if beneficiaryText.isEmpty {
                beneficiaryText = ben.beneficiary
            } else {
                beneficiaryText += " , \(ben.beneficiary)"
            }
        }
        var username : String
        if beneficiaryText == "Kevin Clark" {
            username = "kclark"
            cell.typeImageView.image = UIImage(named: "kclark")
        } else if beneficiaryText == "Grace Davis" {
            username = "gdavis"
            cell.typeImageView.image = UIImage(named: "gdavis")
        } else if beneficiaryText == "Danny Crane" {
            username = "dcrane"
            cell.typeImageView.image = UIImage(named: "dcrane")
        } else if beneficiaryText == "Billie Rojero" {
            username = "brojero"
            cell.typeImageView.image = UIImage(named: "brojero")
        } else {
            cell.typeImageView.image = UIImage(named: "profileBlankPic")
        }
        cell.beneiciaryUserLabel.text = beneficiaryText
        
        //cell.beneiciaryUserLabel.text = task.beneficiearyUser.stringByReplacingOccurrencesOfString("[", withString: "").stringByReplacingOccurrencesOfString("]", withString: "")
        cell.justificationLabel.text = task.requestJustification
        //cell.justificationLabel.bounds = CGRectMake(0, 0, self.tableView.size.width, self.tableView.size.height)
        
        cell.dateLabel.text = task.requestedDate + "   |   Request " + task.requestId
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        if self.tableView.editing {
            cell.approveBtn.enabled = false
            cell.declineBtn.enabled = false
            cell.moreBtn.enabled = false
            cell.moreBtn.hidden = true
        } else {
            cell.approveBtn.enabled = true
            cell.declineBtn.enabled = true
            cell.moreBtn.enabled = true
            cell.moreBtn.hidden = false
        }

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*
        if let indexPath = self.tableView.indexPathsForSelectedRows as? [NSIndexPath]! {
            self.selectedtasks.removeAll(keepCapacity: true)
            for idx in indexPath {
                let info = tasks[idx.item]
                self.selectedtasks.append(info)
            }
            /* not using - save for later
            let selectedcell = tableView.cellForRowAtIndexPath(indexPath)
            
            if (selectedcell!.accessoryType == UITableViewCellAccessoryType.None) {
                selectedcell!.accessoryType = UITableViewCellAccessoryType.Checkmark
                
                //self.selectedtasks.append(info)
                //self.selectedtasks.sort({ $0.requestId < $1.requestId })
            }else{
                selectedcell!.accessoryType = UITableViewCellAccessoryType.None

                //self.selectedtasks.removeAtIndex(indexPath.row)
                //self.selectedtasks.filter() { $0.requestId != info.requestId }
                //self.selectedtasks.sort({ $0.requestId < $1.requestId })
            }*/
        }*/
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let info = tasks[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("ApprovalsDetailViewController") as! ApprovalsDetailViewController
            controller.approvalId = info.requestId
            
            var titleText = ""
            for ent in info.requestEntityName {
                if titleText.isEmpty {
                    titleText = ent.entityname
                } else {
                    titleText += " , \(ent.entityname)"
                }
            }
            
            controller.approvalTitle = titleText
            controller.navigationController
            showViewController(controller, sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemHeading.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView! = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        view.backgroundColor = UIColor(red: 236.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1)
        let lblHeading : UILabel! = UILabel(frame: CGRectMake(20, 0, 200, 20))
        lblHeading.font = UIFont.systemFontOfSize(12)
        lblHeading.textColor = UIColor.darkGrayColor()
        lblHeading.text = itemHeading.objectAtIndex(section) as! NSString as String
        view.addSubview(lblHeading)
        return view
    }
    
    @IBAction func presentNavigation(sender: AnyObject?){
        
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController 
        toViewController.transitioningDelegate = self.transitionOperator

    }
    
    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }

    func buttonAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
        let task = self.tasks[btnsendtag.tag]
        let requestid = task.requestId as String!
        let taskid = task.taskId as String!
        let tasknumber = task.taskNumber as String!
        let taskpriority = task.taskPriority as String!
        let taskstate = task.taskState as String!
        let tasktitle = task.taskTitle as String!
        let taskactioncomments = "" as String!
        var taskaction : String!
        var alerttitle : String!
        var alertmsg : String!
        
        var titleText = ""
        for ent in task.requestEntityName {
            if titleText.isEmpty {
                titleText = ent.entityname
            } else {
                titleText += " , \(ent.entityname)"
            }
        }
        
        if action == "Approve" {
            
            taskaction = "APPROVE"
            alerttitle = "Approval Confirmation"
            alertmsg = "Please confirm approval for " + titleText + " Requested by " + task.requestRaisedByUser
            
        } else if action == "Decline" {
            
            taskaction = "REJECT"
            alerttitle = "Decline Confirmation"
            alertmsg = "Please confirm rejection of " + titleText + " Requested by " + task.requestRaisedByUser
            
        } else if action == "More" {
            
            taskaction = ""
            alerttitle = "More Options"
            alertmsg = ""
        }
        
        var alert : UIAlertController
        var doalert : DOAlertController
        
        if action != "More" {
           
            doalert = DOAlertController(title: alerttitle, message: alertmsg, preferredStyle: .Alert)
            
            // Add the text field for text entry.
            doalert.addTextFieldWithConfigurationHandler { textField in
                // If you need to customize the text field, you can do so here.
                textField.placeholder = " Enter Comments "
            }
            
            let approveAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
                
                let url = myAPIEndpoint + "/approvals"
                
                var paramstring = "{\"requester\": {\"User Login\": \""
                paramstring += myLoginId + "\"},\"task\": [{\"requestId\": \""
                paramstring += requestid + "\",\"taskId\": \""
                paramstring += taskid + "\", \"taskNumber\": \""
                paramstring += tasknumber + "\",\"taskPriority\": \""
                paramstring += taskpriority + "\",\"taskState\": \""
                paramstring += taskstate + "\",\"taskTitle\": \""
                paramstring += tasktitle + "\" ,\"taskActionComments\": \""
                paramstring += textField.text! + "\",\"taskAction\": \""
                paramstring += taskaction + "\"}]}"
                
                self.api.RequestApprovalAction(myLoginId, params : paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
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
            doalert.addAction(approveAction)
            
            presentViewController(doalert, animated: true, completion: nil)
   
        } else {
            doalert = DOAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let approveAction = DOAlertAction(title: "Approve", style: .Destructive) { action in
            }
            let claimAction = DOAlertAction(title: "Claim", style: .Destructive) { action in
            }
            let declineAction = DOAlertAction(title: "Decline", style: .Destructive) { action in
            }
            let delegateAction = DOAlertAction(title: "Delegate", style: .Destructive) { action in
            }
            let resetAction = DOAlertAction(title: "Reset", style: .Destructive) { action in
            }
            let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            // Add the action.
            doalert.addAction(approveAction)
            doalert.addAction(claimAction)
            doalert.addAction(declineAction)
            doalert.addAction(delegateAction)
            doalert.addAction(resetAction)
            doalert.addAction(cancelAction)
            
            presentViewController(doalert, animated: true, completion: nil)
            
        }
    }
}


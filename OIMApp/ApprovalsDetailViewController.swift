//
//  ApprovalsDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 2/16/16.
//  Copyright © 2016 Persistent Systems. All rights reserved.
//

import UIKit

class ApprovalsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    //let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var approvalId : String!
    var approvalTitle : String!
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    var tasks : [Tasks]!
    var api : API!
    var utl : UTIL!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        navigationBar.clipsToBounds = true
        titleLabel.text = approvalTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        self.api = API()
        
        let url = myAPIEndpoint + "/users/" + myLoginId + "/approvals?filter=requestId%20eq%20" + approvalId
        api.loadPendingApprovals(myLoginId, apiUrl: url, completion : didLoadData)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
        
        self.tableView.separatorColor = UIColor.clearColor()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.utl = UTIL()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ApprovalDetailCell") as! ApprovalDetailCell
        
        cell.requestType.text = task.requestType + ":"
        var titleText = ""
        for ent in task.requestEntityName {
            if titleText.isEmpty {
                titleText = ent.entityname
            } else {
                titleText += " , \(ent.entityname)"
            }
        }
        cell.entityName.text = titleText
        
        cell.requestStatus.text = " " + task.requestStatus.stringByReplacingOccurrencesOfString("Request ", withString: "") + " "
        cell.requestStatus.backgroundColor = utl.GetStatusColor(task.requestStatus)
        
        var assigneeText = ""
        for asg in task.assignees {
            assigneeText = asg.assigneename
        }
        cell.avatar.image = utl.GetLocalAvatarByName(assigneeText)
        cell.assignee.text = assigneeText
        cell.requestDate.text = task.requestedDate
        cell.requestId.text = "Request Id:" + task.requestId
        cell.beneficiary.text = task.requestRaisedByUser // need to udpate
        cell.justification.text = task.requestJustification
        
        cell.taskTitle.text = " " + task.taskTitle + " "
        cell.taskTitle.backgroundColor = utl.GetStatusColor(task.taskTitle)
        cell.taskAssignedOn.text = task.taskAssignedOn
        
        var awaitingText = ""
        var previousApproverSpacer: CGFloat = 50
        var previousStatusSpacer: CGFloat = 50
        var previousDateSpacer: CGFloat = 50
        var previousAvatarSpacer: CGFloat = 50
        
        let timelineView = UIView(frame: CGRectMake(0, 0, 2, 36))
        timelineView.center = CGPointMake(34, 305)
        timelineView.backgroundColor = UIColor.lightGrayColor()
        timelineView.alpha = 0.2
        self.tableView.addSubview(timelineView)
        
        for i in 0..<task.taskpreviousapprover[0].requesttaskapprovers.count {
            let previousApproverlbl = UILabel(frame: CGRectMake(0, 0, 74, 21))
            previousApproverlbl.center = CGPointMake(178, 292 + previousApproverSpacer)
            previousApproverlbl.font = UIFont(name: MegaTheme.fontName, size: 12)
            previousApproverlbl.textColor = MegaTheme.lightColor
            previousApproverlbl.text = task.taskpreviousapprover[0].requesttaskapprovers[i].approvers
            self.tableView.addSubview(previousApproverlbl)
            previousApproverSpacer = previousApproverSpacer + 60
            
            let previousStatuslbl = UILabel(frame: CGRectMake(0, 0, 64, 21))
            previousStatuslbl.center = CGPointMake(98, 292 + previousStatusSpacer)
            previousStatuslbl.layer.cornerRadius = 8
            previousStatuslbl.layer.masksToBounds = true
            previousStatuslbl.font = UIFont(name: MegaTheme.fontName, size: 10)
            previousStatuslbl.textColor = UIColor.whiteColor()
            previousStatuslbl.text = " " + task.taskpreviousapprover[0].requesttaskapprovers[i].status + " "
            previousStatuslbl.backgroundColor = utl.GetStatusColor(task.taskpreviousapprover[0].requesttaskapprovers[i].status)
            self.tableView.addSubview(previousStatuslbl)
            previousStatusSpacer = previousStatusSpacer + 60
            
            let previousDatelbl = UILabel(frame: CGRectMake(0, 0, 179, 21))
            previousDatelbl.center = CGPointMake(158, 270 + previousDateSpacer)
            previousDatelbl.font = UIFont(name: MegaTheme.fontName, size: 10)
            previousDatelbl.textColor = MegaTheme.lightColor
            previousDatelbl.text = task.taskpreviousapprover[0].requesttaskapprovers[i].updatedDate
            self.tableView.addSubview(previousDatelbl)
            previousDateSpacer = previousDateSpacer + 60
            
            let previousAvatarImg = utl.GetLocalAvatarByName(task.taskpreviousapprover[0].requesttaskapprovers[i].approvers)
            let previousAvatarImgView = UIImageView(image: previousAvatarImg)
            previousAvatarImgView.frame = CGRect(x: 17, y: 265 + previousAvatarSpacer, width: 36, height: 36)
            self.tableView.addSubview(previousAvatarImgView)
            previousAvatarSpacer = previousAvatarSpacer + 60
            
            
            let previousTimelineView = UIView(frame: CGRectMake(0, 0, 2, 36))
            previousTimelineView.center = CGPointMake(34, 255 + previousAvatarSpacer)
            previousTimelineView.backgroundColor = UIColor.lightGrayColor()
            previousTimelineView.alpha = 0.2
            self.tableView.addSubview(previousTimelineView)
            
            //cell.previousAvatar.image = utl.GetLocalAvatarByName(task.taskpreviousapprover[0].requesttaskapprovers[i].approvers)
            //cell.previousUpdateDate.text = task.taskpreviousapprover[0].requesttaskapprovers[i].updatedDate
            //cell.previousStatus.text = " " + task.taskpreviousapprover[0].requesttaskapprovers[i].status + " "
            //cell.previousStatus.backgroundColor = utl.GetStatusColor(task.taskpreviousapprover[0].requesttaskapprovers[i].status)
            //cell.previousApprover.text = task.taskpreviousapprover[0].requesttaskapprovers[i].approvers

        }
        
        var currentApproverSpacer: CGFloat = 0
        var currentStatusSpacer: CGFloat = 0
        var currentDateSpacer: CGFloat = 0
        var currentAvatarSpacer: CGFloat = 0
        
        for i in 0..<task.taskcurrentapprover[0].requesttaskapprovers.count {
            let currentApproverlbl = UILabel(frame: CGRectMake(0, 0, 74, 21))
            currentApproverlbl.center = CGPointMake(178, 292 + previousApproverSpacer + currentApproverSpacer)
            currentApproverlbl.font = UIFont(name: MegaTheme.fontName, size: 12)
            currentApproverlbl.textColor = MegaTheme.lightColor
            currentApproverlbl.text = task.taskcurrentapprover[0].requesttaskapprovers[i].approvers
            self.tableView.addSubview(currentApproverlbl)
            currentApproverSpacer = previousApproverSpacer + 60
            
            let currentStatuslbl = UILabel(frame: CGRectMake(0, 0, 64, 21))
            currentStatuslbl.center = CGPointMake(98, 292 + previousStatusSpacer + currentStatusSpacer)
            currentStatuslbl.layer.cornerRadius = 8
            currentStatuslbl.layer.masksToBounds = true
            currentStatuslbl.font = UIFont(name: MegaTheme.fontName, size: 10)
            currentStatuslbl.textColor = UIColor.whiteColor()
            currentStatuslbl.text = " " + task.taskcurrentapprover[0].requesttaskapprovers[i].status + " "
            currentStatuslbl.backgroundColor = utl.GetStatusColor(task.taskcurrentapprover[0].requesttaskapprovers[i].status)
            self.tableView.addSubview(currentStatuslbl)
            currentStatusSpacer = previousStatusSpacer + 60
            
            if task.taskcurrentapprover[0].requesttaskapprovers[i].updatedDate.length == 0 {
                awaitingText = "Pending"
            } else {
                awaitingText = task.taskcurrentapprover[0].requesttaskapprovers[i].updatedDate
            }
            let currentDatelbl = UILabel(frame: CGRectMake(0, 0, 179, 21))
            currentDatelbl.center = CGPointMake(158, 270 + previousDateSpacer + currentDateSpacer)
            currentDatelbl.font = UIFont(name: MegaTheme.fontName, size: 10)
            currentDatelbl.textColor = MegaTheme.lightColor
            currentDatelbl.text = awaitingText
            self.tableView.addSubview(currentDatelbl)
            currentDateSpacer = previousDateSpacer + 60
            
            let currentAvatarImg = utl.GetLocalAvatarByName(task.taskcurrentapprover[0].requesttaskapprovers[i].approvers)
            let currentAvatarImgView = UIImageView(image: currentAvatarImg)
            currentAvatarImgView.frame = CGRect(x: 17, y: 265 + previousAvatarSpacer + currentAvatarSpacer, width: 36, height: 36)
            self.tableView.addSubview(currentAvatarImgView)
            currentAvatarSpacer = previousAvatarSpacer + 60
            
            /*
            cell.currentAvatar.image = utl.GetLocalAvatarByName(task.taskcurrentapprover[0].requesttaskapprovers[i].approvers)
            
            if task.taskcurrentapprover[0].requesttaskapprovers[i].updatedDate.length == 0 {
                awaitingText = "Pending"
            } else {
                awaitingText = task.taskcurrentapprover[0].requesttaskapprovers[i].updatedDate
            }
            cell.currentUpdateDate.text = awaitingText
            cell.currentStatus.text = " " + task.taskcurrentapprover[0].requesttaskapprovers[i].status + " "
            cell.currentStatus.backgroundColor = utl.GetStatusColor(task.taskcurrentapprover[0].requesttaskapprovers[i].status)
            cell.currentApprover.text = task.taskcurrentapprover[0].requesttaskapprovers[i].approvers
            */
        }
        
        
        let approveBtn = UIButton(frame: CGRectMake(0, 0, 118, 30))
        approveBtn.center = CGPointMake(90, 290 + currentStatusSpacer)
        approveBtn.tag = indexPath.row
        approveBtn.setTitle("Approve", forState: UIControlState.Normal)
        approveBtn.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        approveBtn.setBackgroundImage(UIImage(named:"btn-approve"), forState: .Normal)
        approveBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        self.tableView.addSubview(approveBtn)
        
        /*
        cell.approveBtn.tag = indexPath.row
        cell.approveBtn.setBackgroundImage(UIImage(named:"btn-approve"), forState: .Normal)
        cell.approveBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        */
        
        let declineBtn = UIButton(frame: CGRectMake(0, 0, 119, 30))
        declineBtn.center = CGPointMake(220, 290 + currentStatusSpacer)
        declineBtn.tag = indexPath.row
        declineBtn.setTitle("Decline", forState: UIControlState.Normal)
        declineBtn.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        declineBtn.setBackgroundImage(UIImage(named:"btn-decline"), forState: .Normal)
        declineBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        self.tableView.addSubview(declineBtn)
        
        /*
        cell.declineBtn.tag = indexPath.row
        cell.declineBtn.setBackgroundImage(UIImage(named:"btn-decline"), forState: .Normal)
        cell.declineBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        */
        
        let moreBtn = UIButton(frame: CGRectMake(0, 0, 52, 30))
        moreBtn.center = CGPointMake(320, 290 + currentStatusSpacer)
        moreBtn.tag = indexPath.row
        moreBtn.setTitle("More", forState: UIControlState.Normal)
        moreBtn.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
        moreBtn.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        moreBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        self.tableView.addSubview(moreBtn)
        
        /*
        cell.moreBtn.tag = indexPath.row
        cell.moreBtn.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        cell.moreBtn.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        */
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func buttonAction(sender:UIButton!)
    {
        let btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
        let task = self.tasks[btnsendtag.tag]
        let requestid = task.requestId as String!
        let taskid = task.taskId as String!
        let tasknumber = task.taskNumber as String!
        let taskpriority = task.taskPriority as String!
        let taskstate = task.taskState as String!
        let tasktitle = task.taskTitle as String!
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
                    let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay")
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
                        let navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
                        let pendingApprovalViewController = storyboard.instantiateViewControllerWithIdentifier("ApprovalsViewController") as! ApprovalsViewController
                        navigationController.viewControllers = [pendingApprovalViewController]
                        self.frostedViewController.contentViewController = navigationController;
                        //self.frostedViewController.hideMenuViewController()
                        
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

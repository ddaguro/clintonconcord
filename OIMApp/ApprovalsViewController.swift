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
    
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    
    var itemHeading: NSMutableArray! = NSMutableArray()
    
    var nagivationStyleToPresent : String?
    
    let transitionOperator = TransitionOperator()
    
    var tasks : [Tasks]!
    var api : API!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.clipsToBounds = true
        
        labelTitle.text = "My Approvals"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)

        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        
        itemHeading.addObject("Approvals")
        
        
        self.tasks = [Tasks]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/approvals/pendingapprovals/" + requestorUserId + "?cursor=1&limit=10"
        api.loadPendingApprovals(url, completion : didLoadData)
        
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    func refresh(){
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/approvals/pendingapprovals/" + requestorUserId + "?cursor=1&limit=10"
        api.loadPendingApprovals(url, completion : didLoadData)
        view.showLoading()
        self.tasks.removeAll()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func didLoadData(loadedData: [Tasks]){
        
        for data in loadedData {
            self.tasks.append(data)
        }
        self.tableView.reloadData()
        self.view.hideLoading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
            
            if isFirstTime {
                
                self.tableView.reloadData()
                if self.tasks.count != 0 {
                    view.showLoading()
                }
                
                isFirstTime = false
            }
    }
/*
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
*/
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
        
        cell.typeImageView.image = UIImage(named: "Clock-1")
        cell.nameLabel.text = task.requestEntityName
        cell.postLabel?.text = task.requestType
        cell.beneficiaryLabel.text = "Beneficiaries"
        cell.beneiciaryUserLabel.text = task.beneficiearyUser
        cell.justificationLabel.text = task.requestJustification
        cell.dateLabel.text = task.requestedDate + "      |      Request " + task.requestId
        return cell
        
    }
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let taskObject = tasks[indexPath.row]
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("ApprovalActionViewController") as! ApprovalActionViewController
            controller.tasks = taskObject
            controller.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            presentViewController(controller, animated: true, completion: nil);
            
        }
    }
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemHeading.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        var view: UIView! = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        view.backgroundColor = UIColor(red: 236.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1)
        var lblHeading : UILabel! = UILabel(frame: CGRectMake(20, 0, 200, 20))
        lblHeading.font = UIFont.systemFontOfSize(12)
        lblHeading.textColor = UIColor.darkGrayColor()
        lblHeading.text = itemHeading.objectAtIndex(section) as! NSString as String
        view.addSubview(lblHeading)
        return view
    }
    
    @IBAction func presentNavigation(sender: AnyObject?){
        
        self.performSegueWithIdentifier("presentTableNavigation", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as! UIViewController
        toViewController.transitioningDelegate = self.transitionOperator

    }
    
    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buttonAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle

        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        
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
        
        if action == "Approve" {
            
            taskaction = "APPROVE"
            alerttitle = "Approval Confirmation"
            alertmsg = "Please confirm approval for " + task.requestEntityName + " Requested by " + task.requestRaisedByUser
            
        } else if action == "Decline" {
            
            taskaction = "REJECT"
            alerttitle = "Decline Confirmation"
            alertmsg = "Please confirm rejection of " + task.requestEntityName + " Requested by " + task.requestRaisedByUser
            
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
            paramstring += requestid + "\",\"taskId\": \""
            paramstring += taskid + "\", \"taskNumber\": \""
            paramstring += tasknumber + "\",\"taskPriority\": \""
            paramstring += taskpriority + "\",\"taskState\": \""
            paramstring += taskstate + "\",\"taskTitle\": \""
            paramstring += tasktitle + "\" ,\"taskActionComments\": \""
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
                    
                    //self.tableView.reloadData()
                    //alert.show()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewControllerWithIdentifier("ApprovalsViewController") as! ApprovalsViewController
                    controller.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}
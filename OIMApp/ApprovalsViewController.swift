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
    
    var imageAsync : UIImage!
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
        let url = Persistent.endpoint + Persistent.baseroot + "/approvals/pendingapprovals/" + requestorUserId + "?cursor=1&limit=10"
        api.loadPendingApprovals(url, completion : didLoadData)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        //---> PanGestureRecognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        self.view.addGestureRecognizer(recognizer)
    }
    
    // MARK: swipe gestures
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.panGestureRecognized(sender)
    }

    
    func refresh(){
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + Persistent.baseroot + "/approvals/pendingapprovals/" + requestorUserId + "?cursor=1&limit=10"
        api.loadPendingApprovals(url, completion : didLoadData)
        
        //view.showLoading()
        
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
        
        var username : String
        if task.beneficiearyUser == "Kevin Clark" {
            username = "kclark"
        } else if task.beneficiearyUser == "Grace Davis" {
            username = "gdavis"
        } else {
            username = "dcrane"
        }
        
        /*
        if let url = NSURL(string: Persistent.endpoint + Persistent.baseroot + "/avatar/" + myRequestorId + "/" + username) {
            if let data = NSData(contentsOfURL: url){
                cell.typeImageView.image = UIImage(data: data)
            }
        }
        */
        let url = NSURL(string: Persistent.endpoint + Persistent.baseroot + "/avatar/" + myRequestorId + "/" + username)
        self.api.getDataFromUrl(url!) { data in
            dispatch_async(dispatch_get_main_queue()) {
                if let postCell = tableView.cellForRowAtIndexPath(indexPath) as? TasksCell {
                    postCell.typeImageView.image = UIImage(data: data!)
                }
            }
        }
        
        //cell.typeImageView.image = UIImage(named: "Clock-1")
        cell.nameLabel.text = task.requestEntityName
        cell.postLabel?.text = task.requestType
        cell.beneficiaryLabel.text = "Beneficiaries"
        cell.beneiciaryUserLabel.text = task.beneficiearyUser
        cell.justificationLabel.text = task.requestJustification
        cell.dateLabel.text = task.requestedDate + "      |      Request " + task.requestId
        return cell
        
    }
    
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
        
        // Dismiss keyboard (optional)
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        
        // Present the view controller
        self.frostedViewController.presentMenuViewController()
        
        // self.performSegueWithIdentifier("presentTableNavigation", sender: self)
        
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
            }
            
            let approveAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
                //PERFORM APPROVAL THRU API
                let url = Persistent.endpoint + Persistent.baseroot + "/approvals/performApprovalAction"
                
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
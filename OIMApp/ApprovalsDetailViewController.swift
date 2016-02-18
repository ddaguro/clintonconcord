//
//  ApprovalsDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 2/16/16.
//  Copyright © 2016 Persistent Systems. All rights reserved.
//

import UIKit

class ApprovalsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    
    var approvalId : String!
    var approvalTitle : String!
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    
    var tasks : [Tasks]!
    var api : API!
    
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
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ApprovalDetailCell") as! ApprovalDetailCell

        
        var titleText = ""
        for ent in task.requestEntityName {
            if titleText.isEmpty {
                titleText = ent.entityname
            } else {
                titleText += " , \(ent.entityname)"
            }
        }
        
        cell.nameLabel.text = titleText
        
        
        var previousApprover = ""

        for i in 0..<task.taskpreviousapprover[0].requesttaskapprovers.count {
            if previousApprover.isEmpty {
                previousApprover = task.taskpreviousapprover[0].requesttaskapprovers[i].approvers
            } else {
                previousApprover += " , \(task.taskpreviousapprover[0].requesttaskapprovers[i].approvers)"
            }
        }
        
        var currentApprover = ""
        
        for i in 0..<task.taskcurrentapprover[0].requesttaskapprovers.count {
            if currentApprover.isEmpty {
                currentApprover = task.taskcurrentapprover[0].requesttaskapprovers[i].approvers
            } else {
                currentApprover += " , \(task.taskcurrentapprover[0].requesttaskapprovers[i].approvers)"
            }
        }

        cell.postLabel?.text = " Previous Approver(s):" + previousApprover + " Current Approver: " + currentApprover
        
        return cell
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

//
//  RequestsViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/26/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView : UITableView!
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var toolbar : UIToolbar!
    
    @IBOutlet var labelTitle: UILabel!
    var nagivationStyleToPresent : String?
    
    var refreshControl:UIRefreshControl!
    
    var isFirstTime = true
    let transitionOperator = TransitionOperator()
    
    var reqs : [Requests]!
    var api : API!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //toolbar.clipsToBounds = true
        labelTitle.text = "My Requests"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        
        self.reqs = [Requests]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/requests/" + requestorUserId + "/requestsRaisedByMe?cursor=1&limit=10"
        api.loadRequests(url, completion : didLoadData)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    func refresh(){
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func didLoadData(loadedData: [Requests]){
        
        for data in loadedData {
            self.reqs.append(data)
        }
        tableView.reloadData()
        self.view.hideLoading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            
            self.tableView.reloadData()
            //view.showLoading()
            
            isFirstTime = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reqs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataObject = reqs[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineCell
        
        if dataObject.reqStatus == "Request Completed" {
            cell.typeImageView.image = UIImage(named: "check-1-icon")
        } else if dataObject.reqStatus == "Request Awaiting Child Requests Completion" {
            cell.typeImageView.image = UIImage(named: "Clock-1")
        } else if dataObject.reqStatus == "Obtaining Operation Approval" {
            cell.typeImageView.image = UIImage(named: "approval")
        } else {
            cell.typeImageView.image = UIImage(named: "check-1-icon")
        }
        
        
        //cell.profileImageView.image = UIImage(named: "profile-pic-1")
        cell.nameLabel.text = dataObject.reqId + " " + dataObject.reqType
        cell.postLabel?.text = dataObject.reqStatus
        cell.dateLabel.text = dataObject.reqCreatedOn
        
        return cell
        
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let reqObject = reqs[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("RequestsDetailViewController") as! RequestsDetailViewController
            controller.reqs = reqObject
            controller.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            //controller.preferredContentSize = CGSizeMake(50, 100)
            //controller.navigationController
            //showViewController(controller, sender: self)
            presentViewController(controller, animated: true, completion: nil);
        }
    }
    */
    
    @IBAction func presentNavigation(sender: AnyObject?){
        
        self.performSegueWithIdentifier("presentTableNavigation", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as! UIViewController
        toViewController.transitioningDelegate = self.transitionOperator
    }
    
}
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
    
    @IBOutlet var lblTotalCounter: UILabel!
    @IBOutlet var labelTitle: UILabel!
    var nagivationStyleToPresent : String?
    
    var itemHeading: NSMutableArray! = NSMutableArray()
    
    var refreshControl:UIRefreshControl!
    
    var isFirstTime = true
    let transitionOperator = TransitionOperator()
    
    var reqs : [Requests]!
    var api : API!
    
    
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
        labelTitle.text = "My Requests"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        
        itemHeading.addObject("Requests")
        
        self.reqs = [Requests]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + Persistent.baseroot + "/requests/" + requestorUserId + "/requestsRaisedByMe?cursor=1&limit=10"
        api.loadRequests(url, completion : didLoadData)
        
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
        let url = Persistent.endpoint + Persistent.baseroot + "/requests/" + requestorUserId + "/requestsRaisedByMe?cursor=1&limit=10"
        api.loadRequests(url, completion : didLoadData)
        
        SoundPlayer.play("upvote.wav")
    }
    
    func didLoadData(loadedData: [Requests]){
        self.reqs = [Requests]()
        
        for data in loadedData {
            self.reqs.append(data)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            view.showLoading()
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
        } else {
            cell.typeImageView.image = UIImage(named: "Clock-1")
        }
        
        //cell.nameLabel.text = dataObject.reqId + " " + dataObject.reqType

        var text = ""
        for action in dataObject.reqTargetEntities {
            if text.isEmpty {
                text = action.entity
            } else {
                text += " , \(action.entity)"
            }
        }
        cell.nameLabel.text = text

        cell.postLabel?.text = dataObject.reqStatus
        cell.dateLabel.text = dataObject.reqCreatedOn
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
    
}
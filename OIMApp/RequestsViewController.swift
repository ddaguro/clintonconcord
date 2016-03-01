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
    
    //---> For Pagination
    var cursor = 1;
    let limit = 10;
    
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
        labelTitle.text = "Track Requests"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        itemHeading.addObject("Requests")
        
        self.reqs = [Requests]()
        self.api = API()
        
        let url = myAPIEndpoint + "/users/" + myLoginId + "/requests?requestsForGivenDays=5&filter=reqCreationDate%20ge%202016-01-01&cursor=\(self.cursor)&limit=\(self.limit)"
        if myRequests.count == 0 {
            api.loadRequests(myLoginId, apiUrl: url, completion : didLoadData)
        } else {
        }
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        //---> PanGestureRecognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        self.view.addGestureRecognizer(recognizer)
    }
    
    func loadMore() {
        
        self.view.showLoading()
        
        let url = myAPIEndpoint + "/users/" + myLoginId + "/requests?requestsForGivenDays=5&filter=reqCreationDate%20ge%202016-01-01&cursor=\(self.cursor)&limit=\(self.limit)"
        api.loadRequests(myLoginId, apiUrl: url, completion : didLoadData)
    }
    
    // MARK: swipe gestures
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.panGestureRecognized(sender)
    }

    
    func refresh(){
        
        let url = myAPIEndpoint + "/users/" + myLoginId + "/requests?requestsForGivenDays=5&filter=reqCreationDate%20ge%202016-01-01&cursor=\(self.cursor)&limit=\(self.limit)"
        api.loadRequests(myLoginId, apiUrl: url, completion : didLoadData)
        SoundPlayer.play("upvote.wav")
    }
    
    func didLoadData(loadedData: [Requests]){
        //self.reqs = [Requests]()
        //myRequests = [Requests]()
        
        for data in loadedData {
            self.reqs.append(data)
            myRequests.append(data)
        }
        
        //self.reqs.sort({ $0.reqId > $1.reqId })
        //myRequests.sort({ $0.reqCreatedOn < $1.reqCreatedOn })
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
        
        self.cursor = self.cursor + 15;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            if myRequests.count == 0 {
                view.showLoading()
            } else {
                view.hideLoading()
            }
            isFirstTime = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myRequests.count == 0 {
            return reqs.count
        } else {
            return myRequests.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataObject = myRequests.count ==  0  ? reqs[indexPath.row] : myRequests[indexPath.row]
        
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
                text = action.entityname
            } else {
                text += " , \(action.entityname)"
            }
        }
        cell.nameLabel.text = text.length == 0 ? dataObject.reqType : text

        cell.postLabel?.text = dataObject.reqStatus.stringByReplacingOccurrencesOfString("Request ", withString: "")
        cell.dateLabel.text = formatDate(dataObject.reqCreatedOn)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        ///---->>> Load More Should Call
        if (indexPath.row == self.reqs.count - 1){
            if (self.cursor <= 100) {
                //print("in CellforRowAtIndexPath -- Calling Load More")
                self.loadMore();
            } else {
                ////--->>> Do Nothing
            }
        }
        
        return cell
        
    }
    
    ///---->>> Also Working for Load More
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRowsInSection(lastSectionIndex) - 1
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
            //--->>> This is the last Cell
            // print("This is the last Cell...")
            // self.loadMore()
        }
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
        // Dismiss keyboard (optional)
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        self.frostedViewController.presentMenuViewController()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController 
        toViewController.transitioningDelegate = self.transitionOperator
    }
    
    func formatDate(dateString: String) -> String {
        /*
        let formatter = NSDateFormatter()
        //Thu Aug 13 18:19:07 EDT 2015
        formatter.dateFormat = "EEE MMM dd H:mm:ss yyyy" //yyyy-MM-dd'T'HH:mm:ssZ
        let date = formatter.dateFromString(dateString.stringByReplacingOccurrencesOfString("EDT", withString: ""))
        
        formatter.dateFormat = "EEE, MMM dd yyyy h:mm a"
        return formatter.stringFromDate(date!)
        */
        let formatter = NSDateFormatter()
        //Thu Aug 13 18:19:07 EDT 2015
        formatter.dateFormat = "EEE MMM dd H:mm:ss yyyy"
        let date = formatter.dateFromString(dateString)
        
        formatter.dateFormat = "EEE, MMM dd yyyy h:mm a"
        //return formatter.stringFromDate(date!)
        return dateString
    }
    
}
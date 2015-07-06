//
//  MakeRequestViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/2/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class MakeRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    
    var nagivationStyleToPresent : String?
    let transitionOperator = TransitionOperator()
    
    var refreshControl:UIRefreshControl!
    var isFirstTime = true
    
    var applications : [Applications]!
    var entitlements : [Entitlements]!
    var api : API!
    
    var filteredTableData = [Applications]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.clipsToBounds = true
        labelTitle.text = "Make A Request"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        self.applications = [Applications]()
        self.entitlements = [Entitlements]()
        
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + Persistent.baseroot + "/accounts/all/" + requestorUserId
        
        //api.loadAllApplications(url, completion : didLoadApplications)
        api.loadAllEntitlements(url, completion : didLoadEntitlements)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            //controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        //self.tableView.reloadData()
        
    }
    
    func refresh(){
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + Persistent.baseroot + "/accounts/all/" + requestorUserId
        
        //api.loadAllApplications(url, completion : didLoadApplications)
        //loadAllEntitlements
        api.loadAllEntitlements(url, completion : didLoadEntitlements)
        SoundPlayer.play("upvote.wav")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func didLoadApplications(loadedApplications: [Applications]){
        self.applications = [Applications]()
        
        for app in loadedApplications {
            self.applications.append(app)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    func didLoadEntitlements(loadedEntitlements: [Entitlements]){
        self.entitlements = [Entitlements]()
        
        for ent in loadedEntitlements {
            self.entitlements.append(ent)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entitlements.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell") as! RequestCell
        
        let dataObject = entitlements[indexPath.row]
        
        
        cell.titleLabel.text = dataObject.entitlementDisplayName
        cell.descriptionLabel.text = dataObject.entitlementDescription
        cell.displaynameLabel.text = dataObject.entitlementName
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell;
        /*
        if (self.resultSearchController.active) {
        let filterdata = filteredTableData[indexPath.row]
        cell.textLabel?.text = filterdata.displayName
        
        return cell
        }
        else {
        cell.titleLabel.text = dataObject.displayName
        cell.descriptionLabel.text = dataObject.description
        cell.displaynameLabel.text = dataObject.applicationInstanceName
        return cell
        }
        */
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let info = entitlements[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("MakeRequestActionViewController") as! MakeRequestActionViewController
            controller.displayName = info.entitlementDisplayName
            controller.appInstanceKey = info.entitlementKey
            controller.catalogId = info.catalogId
            controller.navigationController
            showViewController(controller, sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentNavigation(sender: AnyObject) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        
        // Present the view controller
        self.frostedViewController.presentMenuViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as! UIViewController
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator
        
    }
    /*
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
    //filteredTableData.removeAll(keepCapacity: false)
    
    //let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchController.searchBar.text)
    //let array = (applications as NSArray).filteredArrayUsingPredicate(searchPredicate)
    //filteredTableData = array as! [Applications]
    //self.tableView.reloadData()
    }
    */
}


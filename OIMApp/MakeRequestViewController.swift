//
//  MakeRequestViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/2/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class MakeRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var lblTotalCounter: UILabel!
    
    var nagivationStyleToPresent : String?
    let transitionOperator = TransitionOperator()
    var refreshControl:UIRefreshControl!
    var isFirstTime = true
    
    var roles : [Roles]!
    var entitlements : [Entitlements]!
    var applications : [Applications]!
    var api : API!
    
    var tableData : NSMutableArray! = NSMutableArray()
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    var itemHeading: NSMutableArray! = NSMutableArray()
    
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
        labelTitle.text = "Make A Request"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        itemHeading.addObject("Roles")
        itemHeading.addObject("Entitlements")
        itemHeading.addObject("Accounts")
        
        self.roles = [Roles]()
        self.entitlements = [Entitlements]()
        self.applications = [Applications]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + Persistent.baseroot + "/accounts/all/" + requestorUserId
        
        //api.loadAllRoles(url, completion : didLoadRoles)
        api.loadAllEntitlements(url, completion : didLoadEntitlements)
        //api.loadAllApplications(url, completion : didLoadApplications)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
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
        let url = Persistent.endpoint + Persistent.baseroot + "/accounts/all/" + requestorUserId
        
        //api.loadAllRoles(url, completion : didLoadRoles)
        api.loadAllEntitlements(url, completion : didLoadEntitlements)
        //api.loadAllApplications(url, completion : didLoadApplications)
        SoundPlayer.play("upvote.wav")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func didLoadRoles(loadedRoles: [Roles]){
        self.roles = [Roles]()
        
        for role in loadedRoles {
            self.roles.append(role)
            //self.tableData.addObject(role.roleName)
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
            self.tableData.addObject(ent.entitlementDisplayName)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    func didLoadApplications(loadedApplications: [Applications]){
        self.applications = [Applications]()
        
        for app in loadedApplications {
            self.applications.append(app)
            //self.tableData.addObject(app.displayName)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            /*
            switch (section) {
            case 0: // roles
                return roles.count
            case 1: // entitlements
                return entitlements.count
            case 2: // accounts
                return applications.count
            default:
                return 0
            }
            */
            return entitlements.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell") as! RequestCell
        
        if (self.resultSearchController.active) {
            cell.titleLabel.text = filteredTableData[indexPath.row]
        }
        else {
            
            /*
            switch (indexPath.section) {
            case 0: // roles
                let dataObject = roles[indexPath.row]
                cell.titleLabel.text = dataObject.roleName
                cell.descriptionLabel.text = "n/a"
                cell.displaynameLabel.text = "Role Key: " + "\(dataObject.roleKey)" + " | Catgory Id: " + dataObject.catalogId
            case 1: // entitlements
                let dataObject = entitlements[indexPath.row]
                cell.titleLabel.text = dataObject.entitlementDisplayName
                cell.descriptionLabel.text = dataObject.entitlementDescription
                cell.displaynameLabel.text = "Ent Key: " + "\(dataObject.entitlementKey)" + " | Catgory Id: " + dataObject.catalogId
            case 2: // accounts
                let dataObject = applications[indexPath.row]
                cell.titleLabel.text = dataObject.displayName
                cell.descriptionLabel.text = dataObject.description
                cell.displaynameLabel.text = "App Key: " + "\(dataObject.appInstanceKey)" + " | Catgory Id: " + dataObject.catagoryId
                
            default:
                cell.titleLabel.text = "Other"
            }
            */
            let dataObject = entitlements[indexPath.row]
            cell.titleLabel.text = dataObject.entitlementDisplayName
            cell.descriptionLabel.text = dataObject.entitlementDescription
            cell.displaynameLabel.text = "Ent Key: " + "\(dataObject.entitlementKey)" + " | Catgory Id: " + dataObject.catalogId
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell;
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
            
            self.resultSearchController.active = false
            showViewController(controller, sender: self)
        }
    }
    /*
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
    */
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [String]
        
        self.tableView.reloadData()
    }

}

struct RequestAccess {
    var key : Int
    var catagoryId : String
    var name : String
}


//
//  AccessDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class AccessDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnBack: UIBarButtonItem!
    
    @IBOutlet var labelTitle2: UILabel!
    @IBOutlet var labelTitle: UINavigationItem!
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    var nagivationStyleToPresent : String?
    var catalog : String?

    var applications : [Applications]!
    var entitlements : [Entitlements]!
    var roles : [Roles]!
    
    var api : API!
    var users : Users!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar.clipsToBounds = true
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        self.applications = [Applications]()
        self.entitlements = [Entitlements]()
        self.roles = [Roles]()
        
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/useraccounts/all/" + requestorUserId + "/" + requestorUserId
        
        if catalog == "Applications"{
            labelTitle2.text = "Applications"
            api.loadApplications(url, completion : didLoadApplications)
        } else if catalog == "Entitlements" {
            labelTitle2.text = "Entitlements"
            api.loadEntitlements(url, completion: didLoadEntitlements)
        } else if catalog == "Roles" {
            labelTitle2.text = "Roles"
            api.loadRoles(url, completion : didLoadRoles)
        }
        
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        
    }
    
    func refresh(){
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            
            self.tableView.reloadData()
            view.showLoading()
            
            isFirstTime = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int!
        
        if catalog == "Applications" {
            count = applications.count
        } else if catalog == "Entitlements" {
            count = entitlements.count
        } else if catalog == "Roles" {
            count = roles.count
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("accessMetaCell") as! MetaCell
        
        cell.spacerImage?.image = UIImage(named: "check")
        
        if catalog == "Applications" {
            let dataObject = applications[indexPath.row]
            cell.titleLabel.text = dataObject.displayName
            cell.subtitleLabel.text = dataObject.description
            cell.dateImage?.image = UIImage(named: "clock")
            cell.dateLabel?.text = dataObject.provisionedOnDate
        } else if catalog == "Entitlements" {
            let dataObject = entitlements[indexPath.row]
            cell.titleLabel.text = dataObject.entitlementDisplayName
            cell.subtitleLabel.text = dataObject.entitlementDescription
            cell.dateImage?.image = UIImage(named: "clock")
            cell.dateLabel?.text = dataObject.provisionedOnDate
        } else if catalog == "Roles" {
            let dataObject = roles[indexPath.row]
            cell.titleLabel.text = dataObject.roleName
            cell.subtitleLabel.text = dataObject.description
            cell.dateImage?.image = UIImage(named: "clock")
            cell.dateLabel?.text = dataObject.assignedOn
        }
        
        return cell;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didLoadApplications(loadedApplications: [Applications]){
        
        for app in loadedApplications {
            self.applications.append(app)
        }
        tableView.reloadData()
        
        self.view.hideLoading()
    }
    
    func didLoadRoles(loadedRoles: [Roles]){
        
        for role in loadedRoles {
            self.roles.append(role)
        }
        tableView.reloadData()
        
        self.view.hideLoading()
    }
    
    func didLoadEntitlements(loadedEntitlements: [Entitlements]){
        
        for ent in loadedEntitlements {
            self.entitlements.append(ent)
        }
        tableView.reloadData()
        
        self.view.hideLoading()
    }
    

}


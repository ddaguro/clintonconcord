//
//  AccessDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class AccessDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnBack: UIBarButtonItem!
    
    @IBOutlet var labelTitle2: UILabel!
    @IBOutlet var labelTitle: UINavigationItem!
    
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
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

        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        self.applications = [Applications]()
        self.entitlements = [Entitlements]()
        self.roles = [Roles]()
        
        self.api = API()
        
        let url = Persistent.endpoint + Persistent.baseroot + "/users/" + myLoginId + "/accounts/"
        
        if catalog == "Applications"{
            labelTitle2.text = "Applications"
            api.loadApplications(myLoginId, apiUrl: url, completion: didLoadApplications)
            /*
            if myApplications.count == 0 {
                println("load from api")
                api.loadApplications(myLoginId, apiUrl: url, completion: didLoadApplications)
            } else {
                println("load from storage")
                self.tableView.reloadData()
                self.view.hideLoading()
            }
            */
        } else if catalog == "Entitlements" {
            labelTitle2.text = "Entitlements"
            api.loadEntitlements(myLoginId, apiUrl: url, completion: didLoadEntitlements)
        } else if catalog == "Roles" {
            labelTitle2.text = "Roles"
            api.loadRoles(myLoginId, apiUrl: url, completion : didLoadRoles)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        self.navigationController?.interactivePopGestureRecognizer.delegate = self;

    }
    
    func refresh(){
        
        let url = Persistent.endpoint + Persistent.baseroot + "/users/" + myLoginId + "/accounts/"
        
        if catalog == "Applications"{
            labelTitle2.text = "Applications"
            api.loadApplications(myLoginId, apiUrl: url, completion: didLoadApplications)
        } else if catalog == "Entitlements" {
            labelTitle2.text = "Entitlements"
            api.loadEntitlements(myLoginId, apiUrl: url, completion: didLoadEntitlements)
        } else if catalog == "Roles" {
            labelTitle2.text = "Roles"
            api.loadRoles(myLoginId, apiUrl: url, completion : didLoadRoles)
        }
        
        SoundPlayer.play("upvote.wav")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int!
        
        if catalog == "Applications" {
            /*
            if myApplications.count == 0 {
                count = applications.count
            } else {
                count = myApplications.count
            }*/
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
            cell.subtitleLabel.text = dataObject.description.length == 0 ? dataObject.displayName : dataObject.description
            cell.dateImage?.image = UIImage(named: "clock")
            cell.dateLabel?.text = "Date Provisioned On " + formatDate(dataObject.provisionedOnDate)
        } else if catalog == "Entitlements" {
            let dataObject = entitlements[indexPath.row]
            cell.titleLabel.text = dataObject.entitlementDisplayName
            cell.subtitleLabel.text = dataObject.entitlementDescription.length == 0 ? dataObject.entitlementDisplayName : dataObject.entitlementDescription
            cell.dateImage?.image = UIImage(named: "clock")
            cell.dateLabel?.text = "Date Provisioned On " + formatDate(dataObject.provisionedOnDate)
        } else if catalog == "Roles" {
            let dataObject = roles[indexPath.row]
            cell.titleLabel.text = dataObject.roleName
            cell.subtitleLabel.text = dataObject.description.length == 0 ? dataObject.roleName : dataObject.description
            cell.dateImage?.image = UIImage(named: "clock")
            cell.dateLabel?.text = "Date Assigned On " + formatDate(dataObject.assignedOn)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didLoadApplications(loadedApplications: [Applications]){
        self.applications = [Applications]()
        
        for app in loadedApplications {
            self.applications.append(app)
            //myApplications.append(app)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    func didLoadRoles(loadedRoles: [Roles]){
        self.roles = [Roles]()
        
        for role in loadedRoles {
            self.roles.append(role)
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
    
    func formatDate(dateString: String) -> String {
        
        let formatter = NSDateFormatter()
        //Thu Aug 13 18:19:07 EDT 2015
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString(dateString)
        
        formatter.dateFormat = "EEE, MMM dd yyyy"
        return formatter.stringFromDate(date!)
    }

}


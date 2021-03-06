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
    var showViewLoadMore = true
    var isVeryFirstTime = true
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    var nagivationStyleToPresent : String?
    var catalog : String?

    var applications : [Applications]!
    var entitlements : [Entitlements]!
    var roles : [Roles]!
    
    var api : API!
    var utl : UTIL!
    var users : Users!
    
    //---> For Pagination
    var cursor = 1;
    let limit = 10;
    
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
        
        if catalog == "Applications"{
            let url = myAPIEndpoint + "/users/" + myLoginId + "/applications?cursor=\(self.cursor)&limit=\(self.limit)"
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
            let url = myAPIEndpoint + "/users/" + myLoginId + "/entitlements?cursor=\(self.cursor)&limit=\(self.limit)"
            labelTitle2.text = "Entitlements"
            api.loadEntitlements(myLoginId, apiUrl: url, completion: didLoadEntitlements)
        } else if catalog == "Roles" {
            let url = myAPIEndpoint + "/users/" + myLoginId + "/roles?cursor=\(self.cursor)&limit=\(self.limit)"
            labelTitle2.text = "Roles"
            api.loadRoles(myLoginId, apiUrl: url, completion : didLoadRoles)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
    }
    
    func loadMore() {
        self.showViewLoadMore = true
        
        if catalog == "Applications"{
            let url = myAPIEndpoint + "/users/" + myLoginId + "/applications?cursor=\(self.cursor)&limit=\(self.limit)"
            labelTitle2.text = "Applications"
            api.loadApplications(myLoginId, apiUrl: url, completion: didLoadApplications)
        } else if catalog == "Entitlements" {
            let url = myAPIEndpoint + "/users/" + myLoginId + "/entitlements?cursor=\(self.cursor)&limit=\(self.limit)"
            labelTitle2.text = "Entitlements"
            api.loadEntitlements(myLoginId, apiUrl: url, completion: didLoadEntitlements)
        } else if catalog == "Roles" {
            let url = myAPIEndpoint + "/users/" + myLoginId + "/roles?cursor=\(self.cursor)&limit=\(self.limit)"
            labelTitle2.text = "Roles"
            api.loadRoles(myLoginId, apiUrl: url, completion : didLoadRoles)
        }
    }
    
    func refresh(){
        
        self.cursor = 1
        
        if catalog == "Applications"{
            let url = myAPIEndpoint + "/users/" + myLoginId + "/applications?cursor=\(self.cursor)&limit=\(self.limit)"
            labelTitle2.text = "Applications"
            api.loadApplications(myLoginId, apiUrl: url, completion: didLoadApplications)
        } else if catalog == "Entitlements" {
            let url = myAPIEndpoint + "/users/" + myLoginId + "/entitlements?cursor=\(self.cursor)&limit=\(self.limit)"
            labelTitle2.text = "Entitlements"
            api.loadEntitlements(myLoginId, apiUrl: url, completion: didLoadEntitlements)
        } else if catalog == "Roles" {
            let url = myAPIEndpoint + "/users/" + myLoginId + "/roles?cursor=\(self.cursor)&limit=\(self.limit)"
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

            if self.applications == nil {
                return 0
            }
            
            if self.showViewLoadMore {
                return self.applications.count + 1
                
            } else {
                return applications.count
            }
            
        } else if catalog == "Entitlements" {
            count = entitlements.count
        } else if catalog == "Roles" {
            count = roles.count
        }
    
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        self.utl = UTIL()
        if (indexPath.row < self.applications.count) {
            let cell = tableView.dequeueReusableCellWithIdentifier("accessMetaCell") as! MetaCell
            
            cell.spacerImage?.image = UIImage(named: "check")
            
            if catalog == "Applications" {
                let dataObject = applications[indexPath.row]
                cell.titleLabel.text = dataObject.displayName
                cell.subtitleLabel.text = dataObject.description.length == 0 ? dataObject.displayName : dataObject.description
                cell.dateImage?.image = UIImage(named: "clock")
                cell.dateLabel?.text = "Date Provisioned On " + utl.formatDate(dataObject.provisionedOnDate)
                
                if (myRequest < 10) {
                    //--->>> No Load More Here
                    self.showViewLoadMore = false
                    
                } else {
                    ///---->>> Load More Should Call
                    if (indexPath.row == self.applications.count - 10 /*- 2*/){
                        if (self.cursor <= myApprovals) {
                            //print("in CellforRowAtIndexPath -- Calling Load More")
                            self.loadMore();
                        } else {
                            ////--->>> Do Nothing
                        }
                    }
                }
                
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                
            } else if catalog == "Entitlements" {
                let dataObject = entitlements[indexPath.row]
                cell.titleLabel.text = dataObject.entitlementDisplayName
                cell.subtitleLabel.text = dataObject.entitlementDescription.length == 0 ? dataObject.entitlementDisplayName : dataObject.entitlementDescription
                cell.dateImage?.image = UIImage(named: "clock")
                cell.dateLabel?.text = "Date Provisioned On " + utl.formatDate(dataObject.provisionedOnDate)
            } else if catalog == "Roles" {
                let dataObject = roles[indexPath.row]
                cell.titleLabel.text = dataObject.roleName
                cell.subtitleLabel.text = dataObject.description.length == 0 ? dataObject.roleName : dataObject.description
                cell.dateImage?.image = UIImage(named: "clock")
                cell.dateLabel?.text = "Date Assigned On " + utl.formatDate(dataObject.assignedOn)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        } else if (self.showViewLoadMore == true) {
            
            if self.isVeryFirstTime == true {
                self.isVeryFirstTime = false
                let cell = UITableViewCell()
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreAccess") as! LoadMoreCC
                cell.viewSpinner.frame = CGRectMake(cell.viewSpinner.frame.origin.x, cell.viewSpinner.frame.origin.y, cell.viewSpinner.frame.size.width, 30)
                cell.spinner.color = UIColor(red: 73.0/255.0, green: 143.0/255.0, blue: 225.0/255.0, alpha: 1.0)
                cell.spinner.startAnimating()
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                return cell
            }
            
        } else {
            let cell = UITableViewCell()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return cell
        }
    }
    
    ///---->>> Also Working for Load More
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRowsInSection(lastSectionIndex) - 1
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) {
            //--->>> This is the last Cell
            //print("This is the last Cell...")
            
            // self.loadMore()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didLoadApplications(loadedApplications: [Applications]){
        for app in loadedApplications {
            self.applications.append(app)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        
        //---> Increment Cursor
        self.cursor = self.cursor + 10;
        
        if self.cursor > myApprovals {
            self.showViewLoadMore = false
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
    


}


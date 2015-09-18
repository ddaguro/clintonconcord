//
//  NavigationController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var tableView   : UITableView!
    @IBOutlet var dimmerView  : UIView!
    @IBOutlet var bottomFillView  : UIView!
    
    @IBOutlet var nameLabel  : UILabel!
    @IBOutlet var locationLabel  : UILabel!
    @IBOutlet var locationImageView  : UIImageView!
    @IBOutlet var profileImageView  : UIImageView!
    @IBOutlet var logoutButton  : UIButton!
    
    let transitionOperator = TransitionOperator()
    
    var api : API!
    var users : [Users]!
    var items : [NavigationModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in MenuViewController - NavigationViewController")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(white: 0.20, alpha: 1.0)
        
        let backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        tableView.backgroundColor = backgroundColor
        bottomFillView.backgroundColor = backgroundColor
        
        bgImageView.image = UIImage(named: "side-menu-bg")
        dimmerView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        
        var displayname : String!
        displayname = NSUserDefaults.standardUserDefaults().objectForKey("DisplayName") as! String
        var title : String!
        title = NSUserDefaults.standardUserDefaults().objectForKey("Title") as! String
        
        nameLabel.font = UIFont(name: MegaTheme.fontName, size: 19)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.text = displayname
        
        locationLabel.font = UIFont(name: MegaTheme.fontName, size: 13)
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.text = title
        
        profileImageView.image = UIImage(named: "profileBlankPic")
        profileImageView.layer.cornerRadius = 50
        
        //locationImageView.image = UIImage(named: "location")
        
        logoutButton.titleLabel?.font = UIFont(name: MegaTheme.boldFontName, size: 18)
        logoutButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        logoutButton.setTitle("LOGOUT", forState: .Normal)
        logoutButton.backgroundColor = UIColor(red: 0.83, green: 0.18, blue: 0.21, alpha: 1.0)
        logoutButton.clipsToBounds = true;
        logoutButton.addTarget(self, action: "LoggedOut", forControlEvents: .TouchUpInside)
        
        let item1 = NavigationModel(title: "DASHBOARD", icon: "icon-home", segue: "presentDashboard")
        let item2 = NavigationModel(title: "MY ACCESS", icon: "icon-chat", segue: "presentAccess")
        let item3 = NavigationModel(title: "MY CERTIFICATIONS", icon: "icon-star", segue: "presentCertifications")
        let item4 = NavigationModel(title: "MY APPROVALS", icon: "icon-filter", segue: "presentApprovals")
        let item5 = NavigationModel(title: "MY REQUESTS", icon: "icon-info", segue: "presentRequests")
        let item6 = NavigationModel(title: "MAKE A REQUEST", icon: "icon-info", segue: "presetMakeARequest")
        let item7 = NavigationModel(title: "API DOCS", icon: "icon-info", segue: "presetSwagger")
        
        items = [item1, item2, item3, item4, item5, item6, item7]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 // need to change to count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationCell") as! NavigationCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.countLabel.text = item.count
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //dismissViewControllerAnimated(true, completion: nil)
        
        let info = items[indexPath.row]
        /*
        if(info.segue != "none"){
            let storyboard = UIStoryboard(name: info.segue, bundle: nil)
            let controller = storyboard.instantiateInitialViewController()as! UIViewController
            showViewController(controller, sender: self)
            
        }
        */
        //println(info.segue)
        
        if (info.segue == "presentDashboard") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
            showViewController(controller, sender: self)
        } else if (info.segue == "presentAccess") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("AccessViewController") as! AccessViewController
            showViewController(controller, sender: self)
        } else if (info.segue == "presentCertifications"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("CertficationsViewController") as! CertficationsViewController
            showViewController(controller, sender: self)
        } else if (info.segue == "presentApprovals"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("ApprovalsViewController") as! ApprovalsViewController
            showViewController(controller, sender: self)
        } else if (info.segue == "presentRequests"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("RequestsViewController") as! RequestsViewController
            showViewController(controller, sender: self)
        } else if (info.segue == "presetMakeARequest"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("MakeRequestViewController") as! MakeRequestViewController
            showViewController(controller, sender: self)
        } else if (info.segue == "presetSwagger"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            showViewController(controller, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let controller = segue.destinationViewController as! AccessViewController
        
        //controller.nagivationStyleToPresent = "presentTableNavigation"
        
        let toViewController = segue.destinationViewController 
        toViewController.transitioningDelegate = self.transitionOperator
        
    }
    
    func LoggedOut(){
        
    }
    
    func didLoadUsers(loadedUsers: [Users]){
        //self.users = loadedUsers
        
        for usr in loadedUsers {
            users.append(usr)
        }
    }

}


class NavigationModel {
    
    var title : String!
    var icon : String!
    var count : String?
    var segue:  String!
    
    init(title: String, icon : String, segue: String){
        self.title = title
        self.icon = icon
        self.segue = segue
    }
    
    init(title: String, icon : String, count: String, segue: String){
        
        self.title = title
        self.icon = icon
        self.count = count
        self.segue = segue
    }
}


//
//  MenuViewController.swift
//  OIMApp
//
//  Created by Muhammad Jabbar on 7/1/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    var lblName = UILabel(frame: CGRectMake(0, 150, 0, 24))
    var imageView = UIImageView(frame: CGRectMake(0, 40, 100, 100))
    var api : API!
    var users : [Users]!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = API()
        //println("----->>> MenuViewController")
        
        //---> Adding UIButton in UITableView Footer
        var viewFooter = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
        var btnLogout = UIButton(frame: CGRectMake(10, 10, 150, 40))
        btnLogout.setTitle("LOGOUT", forState: UIControlState.Normal)
        btnLogout.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnLogout.layer.cornerRadius = 5.0
        btnLogout.layer.borderWidth = 2.0
        btnLogout.layer.borderColor = UIColor.whiteColor().CGColor
        btnLogout.clipsToBounds = true
        btnLogout.addTarget(self, action: "btnLogoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        viewFooter.addSubview(btnLogout)
        
        self.tblView.tableFooterView = viewFooter;
        btnLogout.center = CGPointMake(self.tblView.tableFooterView!.frame.size.width / 2 - 20, self.tblView.tableFooterView!.frame.size.height / 2 + 10);
        
        // This will remove extra separators from tableview
        // self.tblView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tblView.separatorColor = UIColor.clearColor() // UIColor(red: 150/255.0, green: 161/255.0, blue: 177/255.0, alpha: 1.0)
        self.tblView.opaque = false
        // self.tblView.backgroundColor = UIColor.lightGrayColor()
        
        //---> Setting UITableView Header

        
        
        var view = UIView(frame: CGRectMake(0, 0, 0, 184.0))
        /*var imageView = UIImageView(frame: CGRectMake(0, 40, 100, 100))*/
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        imageView.image = UIImage(named: "profileBlankPic")
        imageView.layer.masksToBounds = true;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = UIColor.whiteColor().CGColor;
        // imageView.layer.borderWidth = 3.0;
        imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        imageView.layer.shouldRasterize = true;
        imageView.clipsToBounds = true
        
        var displayname = NSUserDefaults.standardUserDefaults().objectForKey("DisplayName") as? String
        // print("viewDidLoad----->>> ")
        // println(displayname)
        lblName.text = displayname
        lblName.font = UIFont(name: "HelveticaNeue", size: 21)
        lblName.backgroundColor = UIColor.clearColor()
        lblName.textColor = UIColor.whiteColor()  // UIColor(red: 62/255.0, green: 68/255.0, blue: 75/255.0, alpha: 1.0)
        lblName.sizeToFit();
        lblName.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        
        var btnSetting = UIButton(frame: CGRectMake(self.view.frame.size.width - 80, 25, 20, 20))
        btnSetting .setImage(UIImage(named: "menuicon-settings"), forState: UIControlState.Normal)
        btnSetting.addTarget(self, action: "btnSettingAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(lblName)
        view.addSubview(btnSetting)
        
        self.tblView.tableHeaderView = view
        // self.tblView.tableHeaderView?.backgroundColor = UIColor.clearColor()
        var bView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        var bimage = UIImage(named: "side-menu-bg")
        var bimageview = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        bimageview.image = bimage
        bView.addSubview(bimageview)
        self.tblView.backgroundView = bView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var displayname = NSUserDefaults.standardUserDefaults().objectForKey("DisplayName") as? String
        // print("displayname----->>> ")
        // println(displayname)
        lblName.text = displayname
        // print("lblName.text ----->>> ")
        // println(lblName.text)
        lblName.sizeToFit();
        lblName.center = CGPointMake(self.tblView.tableFooterView!.frame.size.width / 2, 160);
        lblName.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
        
        //imageView.autoresizingMask.contentMode = UIViewContentMode.ScaleAspectFit
        //let checkedUrl = Persistent.endpoint + Persistent.baseroot + "/users/" + myRequestorId + "/avatar"
        //downloadImage(checkedUrl)
        
        if myLoginId == "kclark" {
            imageView.image = UIImage(named: "kclark")
        } else if myLoginId == "gdavis" {
            imageView.image = UIImage(named: "gdavis")
        } else if myLoginId == "dcrane" {
            imageView.image = UIImage(named: "dcrane")
        } else if myLoginId == "b415713" {
            imageView.image = UIImage(named: "brojero")
        }else {
            imageView.image = UIImage(named: "profileBlankPic")
        }
        /*
        if let url = NSURL(string: Persistent.endpoint + Persistent.baseroot + "/avatar/" + myRequestorId + "/" + myRequestorId) {
            if let data = NSData(contentsOfURL: url){
                imageView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin
                imageView.layer.masksToBounds = true;
                imageView.layer.cornerRadius = 50.0;
                imageView.layer.borderColor = UIColor.whiteColor().CGColor;
                imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
                imageView.layer.shouldRasterize = true;
                imageView.clipsToBounds = true
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.image = UIImage(data: data)
            }
        }
        */
        self.tblView.reloadData()
    }
    
    func btnSettingAction() {
        println("btnSettingAction clicked...")
    }
    
    func btnLogoutAction() {
        // println("btnLogoutAction clicked...")
        
        self.api = API()
        
        let url = Persistent.endpoint + Persistent.baseroot + "/users/logout"
        
        api.LogOut(myLoginId, url: url) { (succeeded: Bool, msg: String) -> () in
            var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            if(succeeded) {
                alert.title = "Success!"
                alert.message = msg
                
                for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
                    NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
                }
                
            }
            else {
                alert.title = "Failed : ("
                alert.message = msg
            }
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Show the alert
                
                if(succeeded)
                {
                    //self.performSegueWithIdentifier("dashboardNav", sender: self)
                    //alert.show()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
                    let signInViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
                    navigationController.viewControllers = [signInViewController]
                    self.frostedViewController.contentViewController = navigationController;
                    self.frostedViewController.hideMenuViewController()
                    
                    /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
                    self.showViewController(controller, sender: self)
                    // Dismiss keyboard (optional)
                    self.view.endEditing(true)
                    self.frostedViewController.view.endEditing(true)
                    // Present the view controller
                    self.frostedViewController.hideMenuViewController()*/
                    
                } else {
                    alert.show()
                }
            })
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MenuCC = self.tblView.dequeueReusableCellWithIdentifier("MenuCC") as! MenuCC
        
        if indexPath.row == 0 {
            cell.lblTitle.text = "DASHBOARD"
            cell.viewImage.image = UIImage(named: "menuicon-dashboard")
            
        } else if indexPath.row == 1 {
            cell.lblTitle.text = "MY ACCESS"
            cell.viewImage.image = UIImage(named: "menuicon-myaccess")
            
        } else if indexPath.row == 2 {
            cell.lblTitle.text = "MY CERTIFICATIONS"
            cell.viewImage.image = UIImage(named: "menuicon-mycertifications")
            if (myCertificates > 0) {
                cell.lblNotification.hidden = false;
                cell.lblNotification.text = myCertificates.description
                cell.lblNotification.layer.cornerRadius = 10;
                cell.lblNotification.layer.masksToBounds = true;
            } else {
                // do nothing
                cell.lblNotification.hidden = true
            }
            
        } else if indexPath.row == 3 {
            cell.lblTitle.text = "MY APPROVALS"
            cell.viewImage.image = UIImage(named: "menuicon-myapprovals")
            if (myApprovals > 0) {
                cell.lblNotification.hidden = false;
                cell.lblNotification.text = myApprovals.description
                cell.lblNotification.layer.cornerRadius = 10;
                cell.lblNotification.layer.masksToBounds = true;
            } else {
                // do nothing
                cell.lblNotification.hidden = true
            }
            
        } else if indexPath.row == 4 {
            cell.lblTitle.text = "MY REQUESTS"
            cell.viewImage.image = UIImage(named: "menuicon-myrequests")
            if (myRequest > 0){
                cell.lblNotification.hidden = false;
                cell.lblNotification.text = myRequest.description
                cell.lblNotification.layer.cornerRadius = 10;
                cell.lblNotification.layer.masksToBounds = true;
            } else {
                // do nothing
                cell.lblNotification.hidden = true
            }
            
        } else if indexPath.row == 5 {
            cell.lblTitle.text = "MAKE A REQUEST"
            cell.viewImage.image = UIImage(named: "menuicon-makearequest")
            
        } else if indexPath.row == 6 {
            cell.lblTitle.text = "API DOCS"
            cell.viewImage.image = UIImage(named: "menu-icon-apidocs")
            
        }  /*else if indexPath.row == 7 {
        cell.lblTitle.text = "LOGOUT"
        }*/
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row == 0) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let dashBoardViewController = storyboard.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
            navigationController.viewControllers = [dashBoardViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()
            
            
        } else if (indexPath.row == 1) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let accessViewController = storyboard.instantiateViewControllerWithIdentifier("AccessViewController") as! AccessViewController
            navigationController.viewControllers = [accessViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()
            
        } else if (indexPath.row == 2) {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let certficationsViewController = storyboard.instantiateViewControllerWithIdentifier("CertficationsViewController") as! CertficationsViewController
            navigationController.viewControllers = [certficationsViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()
            
        } else if (indexPath.row == 3) {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let approvalsViewController = storyboard.instantiateViewControllerWithIdentifier("ApprovalsViewController") as! ApprovalsViewController
            navigationController.viewControllers = [approvalsViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()
            
        } else if (indexPath.row == 4) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let requestsViewController = storyboard.instantiateViewControllerWithIdentifier("RequestsViewController") as! RequestsViewController
            navigationController.viewControllers = [requestsViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()

        } else if (indexPath.row == 5) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let makeRequestViewController = storyboard.instantiateViewControllerWithIdentifier("MakeRequestViewController") as! MakeRequestViewController
            navigationController.viewControllers = [makeRequestViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()
            
        } else if (indexPath.row == 6) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let webViewController = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            navigationController.viewControllers = [webViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()
            
        } /*else if (indexPath.row == 7) {
            
            self.api = API()
            
            var requestorUserId : String!
            requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
            let url = Persistent.endpoint + Persistent.baseroot + "/identity/logout/" + requestorUserId
            
            api.LogOut(url) { (succeeded: Bool, msg: String) -> () in
                var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                if(succeeded) {
                    alert.title = "Success!"
                    alert.message = msg
                    
                    for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
                        NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
                    }
                }
                else {
                    alert.title = "Failed : ("
                    alert.message = msg
                }
                
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    
                    if(succeeded)
                    {
                        //self.performSegueWithIdentifier("dashboardNav", sender: self)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
                        let dashBoardViewController = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! DashboardViewController
                        navigationController.viewControllers = [dashBoardViewController]
                        self.frostedViewController.contentViewController = navigationController;
                        self.frostedViewController.hideMenuViewController()

                        
                        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
                        self.showViewController(controller, sender: self)
                        // Dismiss keyboard (optional)
                        self.view.endEditing(true)
                        self.frostedViewController.view.endEditing(true)
                        // Present the view controller
                        self.frostedViewController.hideMenuViewController()*/
                        
                    } else {
                        alert.show()
                    }
                })
            }
            
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewControllerWithIdentifier("REFrostedNavigationController") as! REFrostedNavigationController
            let dashBoardViewController = storyboard.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
            navigationController.viewControllers = [dashBoardViewController]
            self.frostedViewController.contentViewController = navigationController;
            self.frostedViewController.hideMenuViewController()
            */
        }*/
    }

    func didLoadUsers(loadedUsers: [Users]){
        //self.users = loadedUsers
        
        for usr in loadedUsers {
            users.append(usr)
        }
    }
    
    func downloadImage(url: String){
        //println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        self.api.getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                //println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  DashboardViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/19/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nagivationStyleToPresent : String?
    
    @IBOutlet weak var lblTotalCounts: UILabel!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBAction func goApprovals(sender: AnyObject) {
        self.performSegueWithIdentifier("SegueApprovals", sender: self)
        
    }
    @IBAction func goRequests(sender: AnyObject) {
        self.performSegueWithIdentifier("SegueRequests", sender: self)
    }
    
    @IBAction func goCerts(sender: AnyObject) {
        self.performSegueWithIdentifier("SegueCerts", sender: self)
    }
    var users : [Users]!
    var api : API!
    
    let transitionOperator = TransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("----->>> DashboardViewController")
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        
        myRequestorId = requestorUserId
        
        toolbar.clipsToBounds = true

        labelTitle.text = "My Dashboard"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        menuItem.image = UIImage(named: "menu")
        
        self.users = [Users]()
        self.api = API()
        
        let url = Persistent.endpoint + Persistent.baseroot + "/users/" + requestorUserId
        api.loadUser(requestorUserId, apiUrl: url, completion : didLoadUsers)
        
        getPendingCounts(requestorUserId)
        
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

    
    func didLoadUsers(loadedUsers: [Users]){
        
        for usr in loadedUsers {
            self.users.append(usr)
        }
        tableView.reloadData()
    }
    
    func getPendingCounts(requestorUserId: String) {
        self.lblTotalCounts.layer.cornerRadius = 9;
        lblTotalCounts.layer.masksToBounds = true;
        
        api = API()
        
        let url = Persistent.endpoint + Persistent.baseroot + "/users/" + requestorUserId + "/pendingoperationscount"
        api.getDashboardCount(myLoginId, apiUrl: url, completion: { (success) -> () in
            var approval : Int!
            approval = NSUserDefaults.standardUserDefaults().objectForKey("dashapp") as! Int
            myApprovals = approval
            var cert : Int!
            cert = NSUserDefaults.standardUserDefaults().objectForKey("dashcert") as! Int
            myCertificates = cert
            var requests : Int!
            requests = NSUserDefaults.standardUserDefaults().objectForKey("dashreq") as! Int
            myRequest = requests
            totalCounter = (cert + approval + requests)
            if (totalCounter > 0) {
                self.lblTotalCounts.hidden = false
                self.lblTotalCounts.layer.cornerRadius = 9
                self.lblTotalCounts.layer.masksToBounds = true
                self.lblTotalCounts.text = "\(totalCounter)"
            } else {
                self.lblTotalCounts.hidden = true
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getPendingCounts(myLoginId)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DashboardCell") as! DashboardCell
        
        let info = users[indexPath.row]
        cell.bgImage.image = UIImage(named: "MyDashboard-headerless-1")
        cell.approvalsLabel.text = "\(myApprovals)"
        cell.requestsLabel.text = "\(myRequest)"
        cell.certsLabel.text = "\(myCertificates)"
        cell.titleLabel.text = info.DisplayName
        cell.subtitleLabel.text = info.Email
        
        NSUserDefaults.standardUserDefaults().setObject(info.DisplayName, forKey: "DisplayName")
        NSUserDefaults.standardUserDefaults().setObject(info.Title, forKey: "Title")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        return cell;
    }

    @IBAction func presentNavigation(sender: AnyObject) {
        // Dismiss keyboard (optional)
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
}

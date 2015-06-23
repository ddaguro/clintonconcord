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
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuItem: UIBarButtonItem!
    
    @IBOutlet var toolbar: UIToolbar!
    
    var users : [Users]!
    var api : API!
    
    let transitionOperator = TransitionOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.clipsToBounds = true

        labelTitle.text = "My Dashboard"
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        self.users = [Users]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/identity/" + requestorUserId + "/" + requestorUserId
        api.loadUser(url, completion : didLoadUsers)
        
    }
    
    func didLoadUsers(loadedUsers: [Users]){
        
        for usr in loadedUsers {
            self.users.append(usr)
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("usersMetaCell") as! MetaCell
        
        let info = users[indexPath.row]
        cell.titleLabel.text = ""//info.DisplayName
        cell.subtitleLabel.text = ""
        cell.dateImage?.image = UIImage(named: "")
        cell.dateLabel?.text = ""
        
        NSUserDefaults.standardUserDefaults().setObject(info.DisplayName, forKey: "DisplayName")
        NSUserDefaults.standardUserDefaults().setObject(info.Title, forKey: "Title")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        return cell;
    }

    @IBAction func presentNavigation(sender: AnyObject) {
        if self.nagivationStyleToPresent != nil {
            transitionOperator.transitionStyle = nagivationStyleToPresent!
            self.performSegueWithIdentifier(nagivationStyleToPresent, sender: self)
        } else {
            transitionOperator.transitionStyle = "presentTableNavigation"
            self.performSegueWithIdentifier("presentTableNavigation", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as! UIViewController
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator

    }
}

//
//  MakeRequestViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/2/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class MakeRequestViewController: UIViewController {

    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    
    var nagivationStyleToPresent : String?
    let transitionOperator = TransitionOperator()
    
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.clipsToBounds = true
        labelTitle.text = "Make A Request"
        
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    
    func refresh(){
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


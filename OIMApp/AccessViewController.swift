//
//  AccessViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//
import Foundation
import UIKit

class AccessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewLinks : [ViewInfo]!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var toolbar : UIToolbar!
    
    @IBOutlet var lblTotalCounter: UILabel!
    @IBOutlet var labelTitle: UILabel!
    var nagivationStyleToPresent : String?
    let transitionOperator = TransitionOperator()
       
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
        tableView.tableFooterView = UIView(frame: CGRectZero)
        labelTitle.text = "My Access"
        tableView.delegate = self
        tableView.dataSource = self
        
        viewLinks = [ViewInfo]()
        viewLinks.append(ViewInfo(title: "Applications", segue: "accessNav", description: "Applications that I have access to"))
        viewLinks.append(ViewInfo(title: "Entitlements", segue: "accessNav", description: "My company entitlements"))
        viewLinks.append(ViewInfo(title: "Roles", segue: "accessNav", description: "My Roles within the organization"))
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
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

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewLinks.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MetaCell") as! MetaCell
        
        let info = viewLinks[indexPath.row]
        cell.titleLabel.text = info.title
        cell.subtitleLabel.text = info.description
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let info = viewLinks[indexPath.row]
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let info = viewLinks[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("AccessDetailViewController") as! AccessDetailViewController
            controller.catalog = info.title
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    @IBAction func presentNavigation(sender: AnyObject) {
        
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController as! UIViewController
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator
    }
    
    func doneTapped(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class ViewInfo {
    var title: String!
    var segue:  String!
    var description:  String!
    
    init(title: String, segue: String){
        self.title = title
        self.segue = segue
    }
    
    init(title: String, segue: String, description: String){
        self.title = title
        self.segue = segue
        self.description = description
    }
}
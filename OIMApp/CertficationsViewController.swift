//
//  CertficationsViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/1/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertficationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    
    
    var isFirstTime = true
    var nagivationStyleToPresent : String?
    let transitionOperator = TransitionOperator()
    var refreshControl:UIRefreshControl!
    var certs : [Certs]!
    var api : API!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toolbar.clipsToBounds = true
        
        labelTitle.text = "My Certfications"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
        
        self.certs = [Certs]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/idaas/oig/v1/certifications/users/" + requestorUserId + "/MyPendingCertifications"
        api.loadPendingCerts(url, completion : didLoadData)
        
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didLoadData(loadedData: [Certs]){
        
        for data in loadedData {
            self.certs.append(data)
        }
        self.tableView.reloadData()
        self.view.hideLoading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            
            self.tableView.reloadData()
            if self.certs.count != 0 {
                view.showLoading()
            }
            
            isFirstTime = false
        }
    }
    
    func refresh(){
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/idaas/oig/v1/certifications/users/" + requestorUserId + "/MyPendingCertifications"
        api.loadPendingCerts(url, completion : didLoadData)
        view.showLoading()
        self.certs.removeAll()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.certs == nil
        {
            return 0
        }
        return self.certs!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cert = certs[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CertsCell") as! CertsCell
        
        /*
        cell.approveBtn.tag = indexPath.row
        cell.approveBtn.setBackgroundImage(UIImage(named:"btn-approve"), forState: .Normal)
        cell.approveBtn.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        
        
        cell.declineBtn.tag = indexPath.row
        cell.declineBtn.setBackgroundImage(UIImage(named:"btn-decline"), forState: .Normal)
        cell.declineBtn.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        
        cell.moreBtn.tag = indexPath.row
        cell.moreBtn.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        cell.moreBtn.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        */
        

        
        cell.titleLabel.text = cert.title
        cell.statusImage.image = cert.state == "New" ? UIImage(named: "badge-new") : UIImage(named: "Badge-Assigned")
        cell.assigneesLabel.text = "Assignee"
        cell.assignnesUserLabel.text = cert.asignee
        cell.dateLabel.text = cert.createdDate
        cell.progressLabel.text = "Progress"
        cell.progressImage.image = cert.percentComplete ==  "0.0"  ? UIImage(named: "percent0") : UIImage(named: "percent50")
        cell.percentLabel.text =  cert.percentComplete ==  "0.0"  ? "0" : "50"
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let info = certs[indexPath.row]
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let info = certs[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("CertficationsDetailViewController") as! CertficationsDetailViewController
            controller.certId = info.certificationId
            controller.certTitle = info.title
            controller.certType = info.certificationType
            controller.navigationController
            showViewController(controller, sender: self)
            
            
        }
    }
    
    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
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

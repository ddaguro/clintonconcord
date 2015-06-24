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
    
    var itemHeading: NSMutableArray! = NSMutableArray()
    
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
        
        
        itemHeading.addObject("Certifications")
        
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
        self.certs = [Certs]()
        
        for data in loadedData {
            self.certs.append(data)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func refresh(){
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        let url = Persistent.endpoint + "/webapp/rest/idaas/oig/v1/certifications/users/" + requestorUserId + "/MyPendingCertifications"
        api.loadPendingCerts(url, completion : didLoadData)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemHeading.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        var view: UIView! = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        view.backgroundColor = UIColor(red: 236.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1)
        var lblHeading : UILabel! = UILabel(frame: CGRectMake(20, 0, 200, 20))
        lblHeading.font = UIFont.systemFontOfSize(12)
        lblHeading.textColor = UIColor.darkGrayColor()
        lblHeading.text = itemHeading.objectAtIndex(section) as! NSString as String
        view.addSubview(lblHeading)
        return view
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

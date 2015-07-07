//
//  CertficationsDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/22/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertficationsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var isFirstTime = true
    var refreshControl:UIRefreshControl!
    var certId : Int!
    var certTitle : String!
    var certType: String!
    var certitem : [CertItem]!
    var entitem : [EntitlementItem]!
    var api : API!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.clipsToBounds = true
        titleLabel.text = certTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        self.certitem = [CertItem]()
        self.entitem = [EntitlementItem]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        //idaas/oig/v1/certifications/users/dcrane/CertificationLineItems/49/ApplicationInstance
        //idaas/oig/v1/certifications/users/dcrane/CertificationLineItems/122/Entitlement
        let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/users/" + requestorUserId + "/CertificationLineItems/" + "\(certId)/" + certType
        
        if certType == "ApplicationInstance" {
            api.loadCertItem(url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadEntItem(url, completion : didLoadEntitlementData)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        
        //---> Adding Swipe Gesture
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    // MARK: swipe gestures
    func rightSwiped()
    {
        println("right swiped ")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func leftSwiped()
    {
        println("left swiped ")
    }
    
    func didLoadData(loadedData: [CertItem]){
        self.certitem = [CertItem]()
        for data in loadedData {
            self.certitem.append(data)
        }
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()

    }
    
    func didLoadEntitlementData(loadedData: [EntitlementItem]){
        self.entitem = [EntitlementItem]()
        
        for data in loadedData {
            self.entitem.append(data)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    func refresh(){
        
        let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/users/" + myRequestorId + "/CertificationLineItems/" + "\(certId)/" + certType
        
        if certType == "ApplicationInstance" {
            api.loadCertItem(url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadEntItem(url, completion : didLoadEntitlementData)
        }
        
        SoundPlayer.play("upvote.wav")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int!
        
        if certType == "ApplicationInstance" {
            count = certitem.count
        } else if certType == "Entitlement" {
            count = entitem.count
        }
        
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CertsDetailCell") as! CertsDetailCell
        
        if certType == "ApplicationInstance" {
            let info = certitem[indexPath.row]
            cell.titleLabel.text = info.applicationInstanceName
            cell.riskLabel.text = "Risk"
            
            var itemRiskImage = UIImage()
            if info.itemRisk == "Low Risk" {
                itemRiskImage = UIImage(named: "risk-low")!
            } else if info.itemRisk == "Medium Risk" {
                itemRiskImage = UIImage(named: "risk-medium")!
            } else if info.itemRisk == "High Risk" {
                itemRiskImage = UIImage(named: "risk-high")!
            }
            cell.riskImage.image = itemRiskImage
            cell.riskStatusLabel.text = info.itemRisk
            cell.descriptionLabel.text = info.resourceType + " | cid " + "\(info.certificationId)" + " | type " + info.certificationType + " | aid " + "\(info.applicationInstanceId)"
            cell.progressLabel.text = "Progress"
            
            var percentCompleteImage = UIImage()
            
            if info.percentComplete <= 0 {
                percentCompleteImage = UIImage(named: "percent0")!
            } else if info.percentComplete <= 25 {
                percentCompleteImage = UIImage(named: "percent25")!
            } else if info.percentComplete <= 50 {
                percentCompleteImage = UIImage(named: "percent50")!
            } else if info.percentComplete <= 75 {
                percentCompleteImage = UIImage(named: "percent75")!
            } else if info.percentComplete <= 100 {
                percentCompleteImage = UIImage(named: "percent100")!
            }
            
            cell.progressImage.image = percentCompleteImage
            cell.percentLabel.text = "\(info.percentComplete)"
        } else if certType == "Entitlement" {
            let info = entitem[indexPath.row]
            cell.titleLabel.text = info.applicationInstanceName + " (" + info.entitlementDisplayName + ")"
            cell.riskLabel.text = "Risk"
            
            var itemRiskImage = UIImage()
            if info.itemRisk == "Low Risk" {
                itemRiskImage = UIImage(named: "risk-low")!
            } else if info.itemRisk == "Medium Risk" {
                itemRiskImage = UIImage(named: "risk-medium")!
            } else if info.itemRisk == "High Risk" {
                itemRiskImage = UIImage(named: "risk-high")!
            }
            cell.riskImage.image = itemRiskImage
            cell.riskStatusLabel.text = info.itemRisk
            cell.descriptionLabel.text = info.certificationType + " | cid " + "\(info.certificationId)" + " | type " + info.certificationType + " | eid " + "\(info.entitlementId)"
            cell.progressLabel.text = "Progress"
            
            var percentCompleteImage = UIImage()
            
            if info.percentComplete <= 0 {
                percentCompleteImage = UIImage(named: "percent0")!
            } else if info.percentComplete <= 25 {
                percentCompleteImage = UIImage(named: "percent25")!
            } else if info.percentComplete <= 50 {
                percentCompleteImage = UIImage(named: "percent50")!
            } else if info.percentComplete <= 75 {
                percentCompleteImage = UIImage(named: "percent75")!
            } else if info.percentComplete <= 100 {
                percentCompleteImage = UIImage(named: "percent100")!
            }
            
            cell.progressImage.image = percentCompleteImage
            cell.percentLabel.text = "\(info.percentComplete)"
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("CertficationsActionViewController") as! CertficationsActionViewController
        
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            
            if certType == "ApplicationInstance" {
                let info = certitem[indexPath.row]
                controller.certId = info.certificationId
                controller.certTitle = info.applicationInstanceName
                controller.certType = info.certificationType
                controller.applicationInstanceId = info.applicationInstanceId
            } else if certType == "Entitlement" {
                let info = entitem[indexPath.row]
                controller.certId = info.certificationId
                controller.certTitle = info.applicationInstanceName
                controller.certType = info.certificationType
                controller.entitlementId = info.entitlementId
            }
            controller.navigationController
            showViewController(controller, sender: self)
        }
    }
}

//
//  CertficationsDetailViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/22/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertficationsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
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
    var useritem : [UserItem]!
    var roleitem : [RoleItem]!
    
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
        self.useritem = [UserItem]()
        self.roleitem = [RoleItem]()
        
        self.api = API()
        
        let url = Persistent.endpoint + Persistent.baseroot + "/certifications/certificationlineitems/" + "\(certId)/" + certType
        
        if certType == "ApplicationInstance" {
            api.loadCertItem(myLoginId, apiUrl : url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadEntItem(myLoginId, apiUrl : url, completion : didLoadEntitlementData)
        } else if certType == "User" {
            api.loadUserItem(myLoginId, apiUrl : url, completion : didLoadUserData)
        } else if certType == "Role" {
            api.loadRoleItem(myLoginId, apiUrl : url, completion : didLoadRoleData)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
        
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
    
    func didLoadUserData(loadedData: [UserItem]){
        self.useritem = [UserItem]()
        
        for data in loadedData {
            self.useritem.append(data)
        }
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }
    
    func didLoadRoleData(loadedData: [RoleItem]){
        self.roleitem = [RoleItem]()
        
        for data in loadedData {
            self.roleitem.append(data)
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
        
        let url = Persistent.endpoint + Persistent.baseroot + "/certifications/certificationlineitems/" + "\(certId)/" + certType
        
        if certType == "ApplicationInstance" {
            api.loadCertItem(myLoginId, apiUrl : url, completion : didLoadData)
        } else if certType == "Entitlement" {
            api.loadEntItem(myLoginId, apiUrl : url, completion : didLoadEntitlementData)
        } else if certType == "User" {
            api.loadUserItem(myLoginId, apiUrl : url, completion : didLoadUserData)
        } else if certType == "Role" {
            api.loadRoleItem(myLoginId, apiUrl : url, completion : didLoadRoleData)
        }
        
        SoundPlayer.play("upvote.wav")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int!
        
        if certType == "ApplicationInstance" {
            count = certitem.count
        } else if certType == "Entitlement" {
            count = entitem.count
        } else if certType == "User" {
            count = useritem.count
        } else if certType == "Role" {
            count = roleitem.count
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
        } else if certType == "User" {
            let info = useritem[indexPath.row]
            cell.titleLabel.text = info.firstName + " " + info.lastName
            cell.riskLabel.text = "Risk"
            
            var itemRiskImage = UIImage()
            if info.roleRiskSummary == "Low Risk" {
                itemRiskImage = UIImage(named: "risk-low")!
            } else if info.roleRiskSummary == "Medium Risk" {
                itemRiskImage = UIImage(named: "risk-medium")!
            } else if info.roleRiskSummary == "High Risk" {
                itemRiskImage = UIImage(named: "risk-high")!
            }
            cell.riskImage.image = itemRiskImage
            cell.riskStatusLabel.text = info.roleRiskSummary
            cell.descriptionLabel.text = "cid " + "\(certId)" + " | type " + certType + " | uid " + "\(info.userId)"
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
        } else if certType == "Role" {
            let info = roleitem[indexPath.row]
            cell.titleLabel.text = info.roleDisplayName
            cell.riskLabel.text = "Risk"
            
            var itemRiskImage = UIImage()
            if info.roleItemRisk == "Low Risk" {
                itemRiskImage = UIImage(named: "risk-low")!
            } else if info.roleItemRisk == "Medium Risk" {
                itemRiskImage = UIImage(named: "risk-medium")!
            } else if info.roleItemRisk == "High Risk" {
                itemRiskImage = UIImage(named: "risk-high")!
            }
            cell.riskImage.image = itemRiskImage
            cell.riskStatusLabel.text = info.roleItemRisk
            cell.descriptionLabel.text = "cid " + "\(certId)" + " | type " + certType + " | uid " + "\(info.roleEntityId)"
            cell.progressLabel.text = "Progress"
            
            var percentCompleteImage = UIImage()
            
            if info.rolePercentComplete <= 0 {
                percentCompleteImage = UIImage(named: "percent0")!
            } else if info.rolePercentComplete <= 25 {
                percentCompleteImage = UIImage(named: "percent25")!
            } else if info.rolePercentComplete <= 50 {
                percentCompleteImage = UIImage(named: "percent50")!
            } else if info.rolePercentComplete <= 75 {
                percentCompleteImage = UIImage(named: "percent75")!
            } else if info.rolePercentComplete <= 100 {
                percentCompleteImage = UIImage(named: "percent100")!
            }
            
            cell.progressImage.image = percentCompleteImage
            cell.percentLabel.text = "\(info.rolePercentComplete)"
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("CertficationsActionViewController") as! CertficationsActionViewController
        
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
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
            } else if certType == "User" {
                let info = useritem[indexPath.row]
                controller.certId = certId
                controller.certTitle = info.firstName + " " + info.lastName
                controller.certType = certType
                controller.userId = info.userId
            } else if certType == "Role" {
                let info = roleitem[indexPath.row]
                controller.certId = certId
                controller.certTitle = info.roleDisplayName
                controller.certType = certType
                controller.roleentityId = info.roleEntityId
            }
            controller.navigationController
            showViewController(controller, sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

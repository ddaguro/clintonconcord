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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    var certId : Int!
    var certTitle : String!
    var certType: String!
    
    var certitem : [CertItem]!
    var api : API!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.clipsToBounds = true
        titleLabel.text = certTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        //tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.certitem = [CertItem]()
        self.api = API()
        
        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        //webapp/rest/idaas/oig/v1/certifications/users/dcrane/CertificationLineItems/49/ApplicationInstance
        let url = Persistent.endpoint + Persistent.baseroot + "/idaas/oig/v1/certifications/users/" + requestorUserId + "/CertificationLineItems/" + "\(certId)/" + certType
        api.loadCertItem(url, completion : didLoadData)
        
    }
    func didLoadData(loadedData: [CertItem]){
        
        for data in loadedData {
            self.certitem.append(data)
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return certitem.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CertsDetailCell") as! CertsDetailCell
        
        let info = certitem[indexPath.row]
        
        /*
        cell.certifyButton.tag = indexPath.row
        cell.certifyButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
        cell.certifyButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        
        
        cell.revokeButton.tag = indexPath.row
        cell.revokeButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
        cell.revokeButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        
        cell.moreButton.tag = indexPath.row
        cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        cell.moreButton.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        */
        
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
        
        if info.percentComplete == 0 {
            percentCompleteImage = UIImage(named: "percent0")!
        } else if info.percentComplete == 25 {
            percentCompleteImage = UIImage(named: "percent25")!
        } else if info.percentComplete == 50 {
            percentCompleteImage = UIImage(named: "percent50")!
        } else if info.percentComplete == 75 {
            percentCompleteImage = UIImage(named: "percent75")!
        } else if info.percentComplete == 100 {
            percentCompleteImage = UIImage(named: "percent100")!
        }
        
        cell.progressImage.image = percentCompleteImage
        cell.percentLabel.text = "\(info.percentComplete)"
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let info = certitem[indexPath.row]
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let info = certitem[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("CertficationsActionViewController") as! CertficationsActionViewController
            controller.certId = info.certificationId
            controller.certTitle = info.applicationInstanceName
            controller.certType = info.certificationType
            controller.applicationInstanceId = info.applicationInstanceId
            controller.navigationController
            showViewController(controller, sender: self)
        }
    }
}

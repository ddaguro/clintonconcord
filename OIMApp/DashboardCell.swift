//
//  DashboardCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 7/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var subtitleLabel : UILabel!
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var approvalsLabel: UILabel!
    @IBOutlet var requestsLabel: UILabel!
    @IBOutlet var certsLabel: UILabel!
    
    
    @IBOutlet var imgApprovals: UIImageView!
    @IBOutlet var imgRequests: UIImageView!
    @IBOutlet var imgCertfications: UIImageView!
    
    @IBOutlet var imgRecentActivity: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 14)
        titleLabel.textColor = UIColor.blackColor()
        
        subtitleLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        subtitleLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        /*
        imgApprovals.image = UIImage(named: "chart-pendingapprovals")
        approvalsLabel.font = UIFont(name: MegaTheme.fontName, size: 35)
        approvalsLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        imgRequests.image = UIImage(named: "chart-pendingrequests")
        requestsLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        requestsLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        imgCertfications.image = UIImage(named: "chart-pendingcertifications")
        certsLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        certsLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        imgRecentActivity.image = UIImage(named: "recentactivity")
        */
    }


}

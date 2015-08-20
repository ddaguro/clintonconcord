//
//  DashboardCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 7/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var assigneeHeadingLabel: UILabel!
    @IBOutlet var assigneeLabel: UILabel!
    @IBOutlet var clockImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    //@IBOutlet var approverLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 16)
        titleLabel.textColor = UIColor.blackColor()
        
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true
        statusLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        statusLabel.textColor = UIColor.whiteColor()
        
        assigneeHeadingLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        assigneeHeadingLabel.textColor = MegaTheme.darkColor
        
        assigneeLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        assigneeLabel.textColor = MegaTheme.lightColor
        
        clockImage.image = UIImage(named: "clock")
        clockImage.alpha = 0.20
        
        dateLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        dateLabel.textColor = MegaTheme.lightColor
        
        descriptionLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        descriptionLabel.textColor = MegaTheme.lightColor
        
        //approverLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        //approverLabel.textColor = MegaTheme.lightColor
    }
}

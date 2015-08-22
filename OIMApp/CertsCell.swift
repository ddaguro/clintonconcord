//
//  CertsCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/18/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertsCell: UITableViewCell {
    
    
    @IBOutlet var titleLabel : UILabel!
    
    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var assigneesLabel: UILabel!
    @IBOutlet var assignnesUserLabel: UILabel!
    
    @IBOutlet var dateImageView : UIImageView!
    @IBOutlet var dateLabel : UILabel!
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressImage: UIImageView!
    @IBOutlet var percentLabel: UILabel!
    
    @IBOutlet var statusLabel: UILabel!
    override func awakeFromNib() {
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 14)
        titleLabel.textColor = MegaTheme.darkColor
        
        assigneesLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        assigneesLabel.textColor = MegaTheme.darkColor
        
        statusLabel.layer.cornerRadius = 8
        statusLabel.layer.masksToBounds = true
        statusLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        statusLabel.textColor = UIColor.whiteColor()
        
        assignnesUserLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        assignnesUserLabel.textColor = MegaTheme.lightColor
        
        dateImageView.image = UIImage(named: "clock")
        dateImageView.alpha = 0.20
        
        dateLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        dateLabel.textColor = MegaTheme.lightColor
        
        progressLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        progressLabel.textColor = MegaTheme.lightColor
        
        percentLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        percentLabel.textColor = MegaTheme.lightColor
        
    }
    
}

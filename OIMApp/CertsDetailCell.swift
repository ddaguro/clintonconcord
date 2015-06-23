//
//  CertsDetailCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/22/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class CertsDetailCell: UITableViewCell {
    
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var descriptionLabel : UILabel!
    @IBOutlet var riskLabel: UILabel!
    @IBOutlet var riskStatusLabel: UILabel!
    @IBOutlet var riskImage: UIImageView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressImage: UIImageView!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var certifyButton: UIButton!
    @IBOutlet var revokeButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 16)
        titleLabel.textColor = UIColor.blackColor()
        
        
        descriptionLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        descriptionLabel.textColor = MegaTheme.lightColor
        
        
        riskLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        riskLabel.textColor = MegaTheme.lightColor
        
        
        riskStatusLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        riskStatusLabel.textColor = MegaTheme.lightColor
        
        progressLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        progressLabel.textColor = MegaTheme.lightColor
        
        percentLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        percentLabel.textColor = MegaTheme.lightColor
    }
}

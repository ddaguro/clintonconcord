//
//  RequestCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 7/2/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var displaynameLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 14)
        titleLabel.textColor = MegaTheme.darkColor
        
        descriptionLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        descriptionLabel.textColor = MegaTheme.darkColor
        
        displaynameLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        displaynameLabel.textColor = MegaTheme.lightColor
        
    }
    
}

class RequestActionCell: UITableViewCell {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var descriptionLabel : UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 16)
        titleLabel.textColor = UIColor.blackColor()
        
        descriptionLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        descriptionLabel.textColor = MegaTheme.lightColor
        
    }
}
//
//  MetaCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/20/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//
import Foundation
import UIKit

class MetaCell: UITableViewCell {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var subtitleLabel : UILabel!
    
    @IBOutlet var dateImage: UIImageView?
    @IBOutlet var dateLabel: UILabel?
    
    @IBOutlet var spacerImage: UIImageView?
    
    override func awakeFromNib() {
        
        
        titleLabel.font = UIFont(name: MegaTheme.fontName, size: 14)
        titleLabel.textColor = UIColor.blackColor()
        
        subtitleLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        subtitleLabel.textColor = UIColor(white: 0.6, alpha: 1.0)
        
        dateImage?.image = UIImage(named: "clock")
        dateImage?.alpha = 0.20
        
        dateLabel?.font = UIFont(name: MegaTheme.fontName, size: 10)
        dateLabel?.textColor = MegaTheme.lightColor
        
        spacerImage?.image = UIImage(named: "check")
    }
}


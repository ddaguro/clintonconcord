//
//  TimelineCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation
import UIKit

class TimelineCell : UITableViewCell {
    
    @IBOutlet var entityName : UILabel!
    @IBOutlet var reqStatus : UILabel!
    @IBOutlet var reqCreatedOn : UILabel!
    
    @IBOutlet var dateImageView : UIImageView!
    @IBOutlet var typeImageView : UIImageView!
    
    @IBOutlet var reqType: UILabel!
    
    @IBOutlet var beneficiary: UILabel!
    
    override func awakeFromNib() {
        
        entityName.font = UIFont(name: MegaTheme.fontName, size: 14)
        entityName.textColor = MegaTheme.darkColor
        
        reqStatus.layer.cornerRadius = 8
        reqStatus.layer.masksToBounds = true
        reqStatus.font = UIFont(name: MegaTheme.fontName, size: 10)
        reqStatus.textAlignment = NSTextAlignment.Center
        reqStatus.textColor = UIColor.whiteColor()
        
        dateImageView.image = UIImage(named: "clock")
        dateImageView.alpha = 0.20
        
        reqCreatedOn.font = UIFont(name: MegaTheme.fontName, size: 10)
        reqCreatedOn.textColor = MegaTheme.lightColor
        
        reqType.font = UIFont(name: MegaTheme.fontName, size: 12)
        reqType.textColor = MegaTheme.lightColor
        
        beneficiary.font = UIFont(name: MegaTheme.fontName, size: 12)
        beneficiary.textColor = MegaTheme.lightColor
        
    }
    
    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if reqStatus != nil {
            let label = reqStatus!
            label.preferredMaxLayoutWidth = CGRectGetWidth(label.frame)
        }
    }
    */
}
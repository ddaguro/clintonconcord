//
//  ApprovalDetailCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 2/16/16.
//  Copyright © 2016 Persistent Systems. All rights reserved.
//

import UIKit

class ApprovalDetailCell: UITableViewCell {
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var postLabel : UILabel?
    
    override func awakeFromNib() {
        
        nameLabel.font = UIFont(name: MegaTheme.fontName, size: 14)
        nameLabel.textColor = MegaTheme.darkColor
        
        postLabel?.font = UIFont(name: MegaTheme.fontName, size: 12)
        postLabel?.textColor = MegaTheme.lightColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if postLabel != nil {
            let label = postLabel!
            label.preferredMaxLayoutWidth = CGRectGetWidth(label.frame)
        }
    }
}
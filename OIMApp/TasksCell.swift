//
//  TasksCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/28/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation
import UIKit

class TasksCell : UITableViewCell {
    
    @IBOutlet var typeImageView : UIImageView!
    @IBOutlet var dateImageView : UIImageView!
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var postLabel : UILabel?
    @IBOutlet var dateLabel : UILabel!
    
    @IBOutlet var approveBtn: UIButton!
    @IBOutlet var declineBtn: UIButton!
    @IBOutlet var moreBtn: UIButton!
    
    @IBOutlet var beneficiaryLabel: UILabel!
    @IBOutlet var beneiciaryUserLabel: UILabel!
    @IBOutlet var justificationLabel: UILabel!
    override func awakeFromNib() {
        
        nameLabel.font = UIFont(name: MegaTheme.fontName, size: 14)
        nameLabel.textColor = MegaTheme.darkColor
        
        postLabel?.font = UIFont(name: MegaTheme.fontName, size: 12)
        postLabel?.textColor = MegaTheme.lightColor
        
        dateImageView.image = UIImage(named: "clock")
        dateImageView.alpha = 0.20
        
        dateLabel.font = UIFont(name: MegaTheme.fontName, size: 10)
        dateLabel.textColor = MegaTheme.lightColor
        
        beneficiaryLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        beneficiaryLabel.textColor = MegaTheme.darkColor
        
        beneiciaryUserLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        beneiciaryUserLabel.textColor = MegaTheme.lightColor
        
        justificationLabel.font = UIFont(name: MegaTheme.fontName, size: 12)
        justificationLabel.textColor = MegaTheme.lightColor
        //justificationLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //justificationLabel.numberOfLines = 5
        //justificationLabel.preferredMaxLayoutWidth = 200
        //justificationLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if postLabel != nil {
            let label = postLabel!
            label.preferredMaxLayoutWidth = CGRectGetWidth(label.frame)
        }
    }
}
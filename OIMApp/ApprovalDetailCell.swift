//
//  ApprovalDetailCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 2/16/16.
//  Copyright © 2016 Persistent Systems. All rights reserved.
//

import UIKit

class ApprovalDetailCell: UITableViewCell {
    
    @IBOutlet var requestType : UILabel!
    @IBOutlet var entityName : UILabel!
    @IBOutlet var assignee: UILabel!
    @IBOutlet var requestDate: UILabel!
    @IBOutlet var requestId: UILabel!
    @IBOutlet var beneficiary: UILabel!
    @IBOutlet var justification: UILabel!
    
    @IBOutlet var requestStatus: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var taskTitle: UILabel!
    @IBOutlet var taskAssignedOn: UILabel!
    @IBOutlet var timelineStart: UIImageView!
    
    
    override func awakeFromNib() {
        assignee.font = UIFont(name: MegaTheme.fontName, size: 14)
        assignee.textColor = MegaTheme.darkColor
        
        requestDate.font = UIFont(name: MegaTheme.fontName, size: 10)
        requestDate.textColor = MegaTheme.lightColor
        
        requestId.font = UIFont(name: MegaTheme.fontName, size: 10)
        requestId.textColor = MegaTheme.lightColor
        
        requestStatus.layer.cornerRadius = 8
        requestStatus.layer.masksToBounds = true
        requestStatus.font = UIFont(name: MegaTheme.fontName, size: 10)
        requestStatus.textColor = UIColor.whiteColor()
        
        beneficiary.font = UIFont(name: MegaTheme.fontName, size: 12)
        beneficiary.textColor = MegaTheme.lightColor
        
        requestType.font = UIFont(name: MegaTheme.fontName, size: 12)
        requestType.textColor = MegaTheme.darkColor
        
        entityName.font = UIFont(name: MegaTheme.fontName, size: 12)
        entityName.textColor = MegaTheme.lightColor

        justification.font = UIFont(name: MegaTheme.fontName, size: 12)
        justification.textColor = MegaTheme.lightColor

        // start timeline
        timelineStart.image = UIImage(named: "timeline-start")
        
        taskTitle.layer.cornerRadius = 8
        taskTitle.layer.masksToBounds = true
        taskTitle.font = UIFont(name: MegaTheme.fontName, size: 10)
        taskTitle.textColor = UIColor.whiteColor()
        
        taskAssignedOn.font = UIFont(name: MegaTheme.fontName, size: 10)
        taskAssignedOn.textColor = MegaTheme.lightColor
     }
    
}
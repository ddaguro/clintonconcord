//
//  MenuCC.swift
//  OIMApp
//
//  Created by Muhammad Jabbar on 7/1/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class MenuCC: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var lblNotification: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        // Setting Cell Insets -- Also set the Separator Insets Property in Storyboard
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

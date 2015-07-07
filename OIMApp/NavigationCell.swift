//
//  NavigationTableCell.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation
import UIKit

class NavigationCell : UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var countContainer: UIView!
    
    override func awakeFromNib() {
        
        titleLabel.font = UIFont(name: MegaTheme.boldFontName, size: 16)
        titleLabel.textColor = UIColor.whiteColor()
        
        countLabel.font = UIFont(name: MegaTheme.boldFontName, size: 13)
        countLabel.textColor = UIColor.whiteColor()
        
        countContainer.backgroundColor = UIColor(red: 0.33, green: 0.62, blue: 0.94, alpha: 1.0)
        countContainer.layer.cornerRadius = 15
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        let countNotAvailable = countLabel.text == nil
        
        countContainer.hidden = countNotAvailable
        countLabel.hidden = countNotAvailable
        
    }
}
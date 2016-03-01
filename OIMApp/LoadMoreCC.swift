//
//  LoadMoreCC.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 3/1/16.
//  Copyright © 2016 Persistent Systems. All rights reserved.
//

import UIKit

class LoadMoreCC: UITableViewCell {
    
    
    @IBOutlet weak var viewSpinner: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 20)
        // self.viewSpinner.frame = CGRectMake(self.viewSpinner.frame.origin.x, self.viewSpinner.frame.origin.y, self.viewSpinner.frame.size.width, 20)
        // self.needsUpdateConstraints()
        // self.setNeedsUpdateConstraints()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
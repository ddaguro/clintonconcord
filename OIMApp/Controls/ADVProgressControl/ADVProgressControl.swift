//
//  ADVPieControl.swift
//  Mega
//
//  Created by Tope Abayomi on 02/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable class ADVProgressControl: UIControl {

    var label = UILabel()
    var progressLayer : ADVProgressLayer = ADVProgressLayer()
    
    var labelConstraintTop : NSLayoutConstraint!
    var labelConstraintBottom : NSLayoutConstraint!
    var labelConstraintLeft : NSLayoutConstraint!
    var labelConstraintRight : NSLayoutConstraint!
    
    @IBInspectable var strokeWidth : CGFloat = 15 {
        didSet {
            progressLayer.strokeWidth = strokeWidth
            progressLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var progress : CGFloat = 0.75 {
        didSet {
            progressLayer.progress = progress
            progressLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var gradientStart : UIColor = UIColor.blackColor() {
        didSet {
            progressLayer.gradientStart = gradientStart
            progressLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var gradientEnd : UIColor = UIColor.whiteColor() {
        didSet {
            progressLayer.gradientEnd = gradientEnd
            progressLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var labelFont : UIFont! = UIFont.systemFontOfSize(14) {
        didSet {
            label.font = labelFont
        }
    }
    
    @IBInspectable var labelTextColor : UIColor = UIColor.lightGrayColor() {
        didSet {
            label.textColor = labelTextColor
        }
    }
    
    @IBInspectable var labelText : String = "STATS 2015" {
        didSet {
            label.text = labelText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        
        layer.addSublayer(progressLayer)
        progressLayer.setNeedsDisplay()
        
        self.backgroundColor = UIColor.clearColor()
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        addSubview(label)
        
        let spacing = strokeWidth + (strokeWidth/2)
        
        labelConstraintTop = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: spacing)
        
        labelConstraintBottom = NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -spacing)
        
        labelConstraintLeft = NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: spacing)
        
        labelConstraintRight = NSLayoutConstraint(item: label, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: -spacing)
        
        self.addConstraints([labelConstraintTop, labelConstraintBottom, labelConstraintLeft, labelConstraintRight])
    }
    
    func updateProgress(){
        progressLayer.progress = progress
        progressLayer.setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        
        progressLayer.frame = bounds

        label.font = labelFont
        label.text = labelText
        label.textColor = labelTextColor
        
        let spacing = strokeWidth + (strokeWidth/2)
        labelConstraintTop.constant = spacing
        labelConstraintBottom.constant = -spacing
        labelConstraintLeft.constant = spacing
        labelConstraintRight.constant = -spacing
    }
}
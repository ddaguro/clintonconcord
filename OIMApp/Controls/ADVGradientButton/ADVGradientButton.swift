//
//  ADVGradientButton.swift
//  Mega
//
//  Created by Tope Abayomi on 04/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable class ADVGradientButton: UIButton {
    
    var gradientLayer = CAGradientLayer()

    @IBInspectable var gradientStart : UIColor = UIColor(red: 0.22, green: 0.64, blue: 0.89, alpha: 1.0) {
        didSet {

        }
    }
    
    @IBInspectable var gradientEnd : UIColor = UIColor(red: 0.25, green: 0.83, blue: 0.73, alpha: 1.0) {
        didSet {
            
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
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [gradientStart.CGColor, gradientEnd.CGColor]
        gradientLayer.startPoint = CGPointMake(0.0, 0.5)
        gradientLayer.endPoint = CGPointMake(1.0, 0.5)
        
        layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = self.bounds
    }
}


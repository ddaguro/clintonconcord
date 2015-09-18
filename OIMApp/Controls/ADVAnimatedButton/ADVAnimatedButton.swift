//
//  ADVAnimatedButton.swift
//  Mega
//
//  Created by Tope Abayomi on 10/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ADVAnimatedButton: UIButton {
    
    var refreshImageView = UIImageView(frame: CGRectZero)
    
    var animating : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @IBInspectable var imageToShow : UIImage = UIImage(named: "sync")! {
        didSet {
            refreshImageView.image = imageToShow.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
    
    func setupView(){
        refreshImageView.image = UIImage(named: "sync")?.imageWithRenderingMode(.AlwaysTemplate)
        refreshImageView.tintColor = UIColor(white: 1.0, alpha: 0.5)
        refreshImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(refreshImageView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let heightConstraint = NSLayoutConstraint(item: refreshImageView, attribute: .Height, relatedBy: .Equal, toItem: titleLabel, attribute: .Height, multiplier: 1.0, constant: 0.0)
        
        let aspectRatioConstraint = NSLayoutConstraint(item: refreshImageView, attribute: .Height, relatedBy: .Equal, toItem: refreshImageView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        
        let horizontalSpacingConstraint = NSLayoutConstraint(item: refreshImageView, attribute: .Right, relatedBy: .Equal, toItem: titleLabel, attribute: .Left, multiplier: 1.0, constant: -10.0)
        
        let topConstraint = NSLayoutConstraint(item: refreshImageView, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1.0, constant: 0.0)
        
        refreshImageView.addConstraint(aspectRatioConstraint)
        
        addConstraints([heightConstraint, horizontalSpacingConstraint, topConstraint])
        
         let horizontalCenterConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        
        let verticalCenterConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        
        addConstraints([horizontalCenterConstraint, verticalCenterConstraint])
    }
    
    func startAnimating(){
        
        if !animating {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.toValue =  M_PI * 2.0
            animation.cumulative = true
            animation.duration = 1.0
            animation.repeatCount = 10000
            
            refreshImageView.layer.addAnimation(animation, forKey: "rotationAnimation")
            
            animating = true
        }
    }
    
    func stopAnimating(){
        
        CATransaction.begin()
        refreshImageView.layer.removeAllAnimations()
        CATransaction.commit()
        animating = false
        
    }
    

}


//
//  ADVProgressLayer.swift
//  Mega
//
//  Created by Tope Abayomi on 03/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import Foundation
import UIKit

class ADVProgressLayer: CALayer {
    
    var strokeWidth : CGFloat = 10
    var gradientStart : UIColor = UIColor.blackColor()
    var gradientEnd : UIColor = UIColor.whiteColor()
    var progress : CGFloat = 0.75
    
    func makeAnimationForKey(key: String) -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = presentationLayer().valueForKey(key)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 1.5
        
        return animation
    }
    
    override func actionForKey(event: String!) -> CAAction! {
        if (event == "progress" && presentationLayer() != nil) {
            return makeAnimationForKey(event)
        }
        
        return super.actionForKey(event)
    }
    
    override class func needsDisplayForKey(key: String!) -> Bool{
        if (key == "progress" || key == "gradientStart" || key == "gradientEnd" || key == "strokeWidth") {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    override func drawInContext(context: CGContext!) {
        
        var radius = min(self.bounds.size.width, self.bounds.size.height)/2.0
        radius -= (strokeWidth/2);
        
        let width : CGFloat = frame.size.width
        let height : CGFloat = frame.size.height
        let arc : CGFloat = CGFloat(M_PI) * 2.0
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        let imageCtx = UIGraphicsGetCurrentContext()
        
        CGContextAddArc(imageCtx, width/2, height/2, radius, 0, toRadians(self.progress*360), 0)
        
        UIColor.redColor().set()
        
        CGContextSetLineWidth(imageCtx, strokeWidth)
        CGContextDrawPath(imageCtx, kCGPathStroke)
        
        let mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext())
        UIGraphicsEndImageContext()
        
        CGContextSaveGState(context)
        CGContextClipToMask(context, self.bounds, mask)
        
        
        let components : [CGFloat] = getAllComponents()
        
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(baseSpace, components, nil, 2)
        
        let rect = self.bounds
        let startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        let endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        
        CGContextRestoreGState(context);

    }
    
    func toRadians(angleToConvert: CGFloat) -> CGFloat {
        return (CGFloat(M_PI) * (angleToConvert)) / 180.0
    }
    
    func getAllComponents() -> [CGFloat] {
        
        var components = getComponentsFromColor(gradientStart)
        components += getComponentsFromColor(gradientEnd)
        return components
    }
    
    func getComponentsFromColor(color: UIColor) -> [CGFloat] {
        
        let count = CGColorGetNumberOfComponents(color.CGColor)
        let components = CGColorGetComponents(color.CGColor)
        
        if count == 2 {
            return [components[0], components[0], components[0], components[1]]
        }else{
            return [components[0], components[1], components[2], components[3]]
        }
    }

}
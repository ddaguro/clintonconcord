//
//  Utility.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 2/22/16.
//  Copyright © 2016 Persistent Systems. All rights reserved.
//

import Foundation

class UTIL {

    func GetStatusColor (requeststatus: String) -> UIColor {
        
        var statuscolor : UIColor
        
        switch requeststatus {
            
        case "Request Rejected":
            statuscolor = self.UIColorFromHex(0xed7161, alpha: 1.0)
            break;
        case "Request Awaiting Approval":
            statuscolor = self.UIColorFromHex(0xeeaf4b, alpha: 1.0)
            break;
        case "Request Completed":
            statuscolor = self.UIColorFromHex(0x88c057, alpha: 1.0)
            break;
        case "Request Awaiting Child Requests Completion":
            statuscolor = self.UIColorFromHex(0x47a0db, alpha: 1.0)
            break;
        case "Request Approved Fulfillment Pending":
            statuscolor = self.UIColorFromHex(0x9777a8, alpha: 1.0)
            break;
        case "Request Awaiting Dependent Request Completion":
            statuscolor = self.UIColorFromHex(0x47a0db, alpha: 1.0)
            break;
        case "APPROVE":
            statuscolor = self.UIColorFromHex(0x88c057, alpha: 1.0)
            break;
        case "ASSIGNED":
            statuscolor = self.UIColorFromHex(0x3aa99e, alpha: 1.0)
            break;
        default:
            statuscolor = self.UIColorFromHex(0x546979, alpha: 1.0)
            break;
        }
        return statuscolor
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func GetLocalAvatarByName (username: String) -> UIImage {
        
        var avatarimage : UIImage!
        
        switch username {
            
        case "Kevin Clark":
            avatarimage = UIImage(named: "kclark")
            break;
        case "Danny Crane":
            avatarimage = UIImage(named: "dcrane")
            break;
        case "Grace Davis":
            avatarimage = UIImage(named: "gdavis")
            break;
        case "Jerry Freel":
            avatarimage = UIImage(named: "brojero")
            break;
        default:
            avatarimage = UIImage(named: "profileBlankPic")

            break;
        }
        return avatarimage
    }
    
    func GetLocalAvatarByUserName (username: String) -> UIImage {
        
        var avatarimage : UIImage!
        
        switch username {
            
        case "kclark":
            avatarimage = UIImage(named: "kclark")
            break;
        case "dcrane":
            avatarimage = UIImage(named: "dcrane")
            break;
        case "gdavis":
            avatarimage = UIImage(named: "gdavis")
            break;
        case "jfreel":
            avatarimage = UIImage(named: "brojero")
            break;
        default:
            avatarimage = UIImage(named: "profileBlankPic")
            
            break;
        }
        return avatarimage
    }
    
    func GetConvertedStatus (timelineStatus: String) -> String {
        
        var status : String
        
        switch timelineStatus {
            
        case "APPROVE":
            status = "Approve"
            break;
        case "ASSIGNED":
            status = "Assigned"
            break;
        default:
            status = " Pending "
            break;
        }
        return status
    }
    
    func formatDate(dateString: String) -> String {
        
        let formatter = NSDateFormatter()
        //Thu Aug 13 18:19:07 EDT 2015
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString(dateString)
        
        formatter.dateFormat = "EEE, MMM dd yyyy"
        return formatter.stringFromDate(date!)
    }
}



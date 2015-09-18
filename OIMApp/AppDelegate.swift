//
//  AppDelegate.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

var myCertificates: Int = 0
var myApprovals: Int = 0
var myRequest: Int = 0
var totalCounter: Int = 0
var myRequestorId : String = ""


var myLoginId : String = ""

/* for caching */
public var myRequests : [Requests]!
var myApplications : [Applications]!
var myActivities : [Activities]!
var myFIDO : Bool = false

var myClientId : String = "TestClient"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        //NSURLCache.setSharedURLCache(URLCache)
        myRequests = [Requests]()
        myApplications = [Applications]()
        let navAppearance = UINavigationBar.appearance()
        //48A0DC
        //navAppearance.tintColor = uicolorFromHex(0xf48A0DC)
        //navAppearance.barTintColor = uicolorFromHex(0x48A0DC)
        
        let backImage = UIImage(named: "back")
        navAppearance.backIndicatorImage = backImage
        navAppearance.backIndicatorTransitionMaskImage = backImage
        
        let textAttributes : NSMutableDictionary = NSMutableDictionary()
        textAttributes.setObject(UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        textAttributes.setObject(UIFont(name: MegaTheme.fontName, size: 19)!, forKey: NSFontAttributeName)
        
        //navAppearance.titleTextAttributes = textAttributes as [NSObject : AnyObject]
        //navAppearance.tintColor = UIColor.blackColor()
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Compact)

        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        let host = Persistent.endpoint
        NSUserDefaults.standardUserDefaults().setObject(host, forKey: "endpoint")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // MARK: - Slide menu methods
    func setSideMenu() {
        print("setSlideMenu is Called...")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Create frosted view controller
        let frostedViewController: REFrostedViewController = storyboard.instantiateViewControllerWithIdentifier("RootViewController") as! REFrostedViewController
        frostedViewController.direction = REFrostedViewControllerDirection.Left
        
        // Make it a root controller
        self.window!.rootViewController = frostedViewController;
    }

    
}

   // MARK: - Custom Methods

func uicolorFromHex(rgbValue:UInt32)->UIColor{
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:1.0)
}

struct Persistent {
    
    // http://73.50.120.243:9190
    // http://ec2-52-11-216-76.us-west-2.compute.amazonaws.com:8080/
    // http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9080/
    // http://idaasapi.persistent.com:9080/
    //"host" : "idaasapi.persistent.com:9080",
    //"basePath" : "/idaas/oig/v1",
    /*
    9441 (HTTP)
    9442 (HTTPS – 1 way SSL)
    9443 (HTTPS – 1 way SSL with Basic Auth), use s_APIUser/password
    */
    static let endpoint = "http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9441/"
    static let baseroot = "idaas/im/v1"
}

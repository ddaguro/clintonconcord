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
var myToken : String = ""
var myDisplayName : String = ""

var myAPIEndpoint : String = ""

var myLoginId : String = ""

/* for caching */
public var myRequests : [Requests]!
var myApplications : [Applications]!
var myActivities : [Activities]!
var myFIDO : Bool = false

var myClientId : String = "DevClient"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum Actions:String{
        case approve = "APPROVE_ACTION"
        case decline = "DECLINE_ACTION"
        case cancel = "CANCEL_ACTION"
    }
    
    var categoryID:String {
        get{
            return "APPROVALS_CATEGORY"
        }
    }
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        myRequests = [Requests]()
        myApplications = [Applications]()
        
        let navAppearance = UINavigationBar.appearance()
        
        let backImage = UIImage(named: "back")
        navAppearance.backIndicatorImage = backImage
        navAppearance.backIndicatorTransitionMaskImage = backImage
        
        let textAttributes : NSMutableDictionary = NSMutableDictionary()
        textAttributes.setObject(UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        textAttributes.setObject(UIFont(name: MegaTheme.fontName, size: 19)!, forKey: NSFontAttributeName)
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Compact)
        
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        let host = Persistent.endpoint
        NSUserDefaults.standardUserDefaults().setObject(host, forKey: "endpoint")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        //UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        registerNotification()
        
        return true
    }
    
    // Register notification settings
    func registerNotification() {
        
        // 1. Create the actions **************************************************
        
        // increment Action
        let incrementAction = UIMutableUserNotificationAction()
        incrementAction.identifier = Actions.approve.rawValue
        incrementAction.title = "APPROVE"
        incrementAction.activationMode = UIUserNotificationActivationMode.Background
        incrementAction.authenticationRequired = true
        incrementAction.destructive = false
        
        // decrement Action
        let decrementAction = UIMutableUserNotificationAction()
        decrementAction.identifier = Actions.decline.rawValue
        decrementAction.title = "DECLINE"
        decrementAction.activationMode = UIUserNotificationActivationMode.Background
        decrementAction.authenticationRequired = true
        decrementAction.destructive = false
        
        // reset Action
        let resetAction = UIMutableUserNotificationAction()
        resetAction.identifier = Actions.cancel.rawValue
        resetAction.title = "CANCEL"
        resetAction.activationMode = UIUserNotificationActivationMode.Foreground
        // NOT USED resetAction.authenticationRequired = true
        resetAction.destructive = true
        
        
        // 2. Create the category ***********************************************
        
        // Category
        let counterCategory = UIMutableUserNotificationCategory()
        counterCategory.identifier = categoryID
        
        // A. Set actions for the default context
        counterCategory.setActions([incrementAction, decrementAction, resetAction],
            forContext: UIUserNotificationActionContext.Default)
        
        // B. Set actions for the minimal context
        counterCategory.setActions([incrementAction, decrementAction],
            forContext: UIUserNotificationActionContext.Minimal)
        
        
        // 3. Notification Registration *****************************************
        
        let types: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: counterCategory) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    // Schedule the Notifications with repeat
    func scheduleNotification() {
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        // Schedule the notification ********************************************
        if UIApplication.sharedApplication().scheduledLocalNotifications!.count == 0 {
            
            let notification = UILocalNotification()
            notification.alertBody = "Kevin Clark is requesting West Data Center Access"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = NSDate(timeIntervalSinceNow: 15)
            notification.category = categoryID
            //notification.repeatInterval = NSCalendarUnit.Minute
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        //scheduleNotification()
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
            
            // Handle notification action *****************************************
            if notification.category == categoryID {
                
                let action:Actions = Actions(rawValue: identifier!)!

                
                switch action{
                    
                case Actions.approve: break
                    //
                    
                case Actions.decline: break
                    //
                    
                case Actions.cancel: break
                    //
                    
                }
            }
            
            completionHandler()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // Do something serious in a real app.
        print("Received Local Notification:")
        print(notification.alertBody)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Got token data! \(deviceToken)")
        //439af1a9 fc3e8597 110d5e40 1bc36b97 96da2a6e ff0521b7 8f769ad6 f720d162
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Couldn't register: \(error)")
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
    static let endpoint = myAPIEndpoint
    static let baseroot = "idaas/im/v1"
}

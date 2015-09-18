//
//  SignInViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/7/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class SignInViewController : UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var titleLabel : UILabel!
    
    @IBOutlet var facebookButton : UIButton!
    @IBOutlet var twitterButton : UIButton!
    
    
    @IBOutlet var noAccountButton : UIButton!
    
    @IBOutlet var bgImageView : UIImageView!
    
    @IBOutlet var signInButton : UIButton!
    
    @IBOutlet var forgotPassword : UIButton!
    
    @IBOutlet var passwordContainer : UIView!
    @IBOutlet var passwordLabel : UILabel!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var passwordUnderline : UIView!
    
    @IBOutlet var userContainer : UIView!
    @IBOutlet var userLabel : UILabel!
    @IBOutlet var userTextField : UITextField!
    @IBOutlet var userUnderline : UIView!
    
    var api : API!
    var users : [Users]!
    let transitionOperator = TransitionOperator()
    
    var FIDOusername : String = ""
    var FIDOpassword : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide
        facebookButton.hidden = true
        twitterButton.hidden = true
        titleLabel.hidden = true
        
        noAccountButton.setTitle("Sign In with FIDO", forState: .Normal)
        noAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        noAccountButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        noAccountButton.layer.borderWidth = 3
        noAccountButton.layer.borderColor = UIColor.whiteColor().CGColor
        noAccountButton.layer.cornerRadius = 5
        noAccountButton.addTarget(self, action: "LoggedInFIDO", forControlEvents: .TouchUpInside)
        
        //println("----->>> SignInViewController")
        bgImageView.image = UIImage(named: "login-bg")
        bgImageView.contentMode = .ScaleAspectFill
        
        userContainer.backgroundColor = UIColor.clearColor()
        
        userLabel.text = "Username"
        userLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        userLabel.textColor = UIColor.whiteColor()
        
        userTextField.delegate = self
        userTextField.text = myLoginId
        userTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        userTextField.textColor = UIColor.whiteColor()
        
        passwordContainer.backgroundColor = UIColor.clearColor()
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordLabel.textColor = UIColor.whiteColor()
        
        passwordTextField.delegate = self
        passwordTextField.text = ""
        passwordTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.secureTextEntry = true
        
        forgotPassword.setTitle("", forState: .Normal)
        forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        forgotPassword.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        //forgotPassword.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        signInButton.layer.borderWidth = 3
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.cornerRadius = 5
        signInButton.addTarget(self, action: "LoggedIn", forControlEvents: .TouchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }
        
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        self.view.endEditing(true)
        self.LoggedIn()
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! DashboardViewController
        controller.nagivationStyleToPresent = "presentTableNavigation"
    }
    
    func LoggedInFIDO(){
        
        if self.ReadLogin() {
            if myLoginId != self.userTextField.text {
                let alert = UIAlertView(title: "Failed \u{1F44E}", message: "FIDO UAF Authenication Failed", delegate: nil, cancelButtonTitle: "Okay")
                alert.show()
                dismissViewControllerAnimated(true, completion: nil)
            } else {
                let context = LAContext()
                var error: NSError?
                
                // check if Touch ID is available
                if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
                
                    //try context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
                    let reason = "Authenticate with Touch ID"
                    context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                        {(succes: Bool, error: NSError?) in
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if succes {
                                    myFIDO = true
                                    //var alert = UIAlertView(title: "Success \u{1F44D}", message: "FIDO UAF Authenication Succeeded", delegate: nil, cancelButtonTitle: "Okay")
                                    //alert.show()
                                    
                                    self.api = API()
                                    
                                    let url = Persistent.endpoint + Persistent.baseroot + "/users/login"
                                    
                                    //self.ReadLogin()
                                    
                                    //var username = self.userTextField.text
                                    //var password = "Oracle123"
                                    let username = self.FIDOusername
                                    let password = self.FIDOpassword
                                    
                                    let paramstring = "username=" + username + "&password=" + password
                                    
                                    if username != "" {
                                        self.api.LogIn(username, params: paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
                                            let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay")
                                            if(succeeded) {
                                                alert.title = "Success!"
                                                alert.message = msg
                                                
                                                //load user object
                                                self.users = [Users]()
                                                
                                                let url = Persistent.endpoint + Persistent.baseroot + "/users/" + username
                                                self.api.loadUser(username, apiUrl: url, completion : self.didLoadUsers)
                                                
                                                //myLoginId = username
                                                
                                                let appGroupID = "group.com.persistent.plat-sol.OIGApp"
                                                
                                                if let defaults = NSUserDefaults(suiteName: appGroupID) {
                                                    defaults.setValue(username, forKey: "requestorUserId")
                                                }
                                                
                                                NSUserDefaults.standardUserDefaults().setObject(username, forKey: "requestorUserId")
                                                NSUserDefaults.standardUserDefaults().synchronize()
                                                
                                                myLoginId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String

                                            }
                                            else {
                                                alert.title = "Failed : ("
                                                alert.message = msg
                                            }
                                            
                                            // Move to the UI thread
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                if(succeeded)
                                                {
                                                    self.performSegueWithIdentifier("SegueDashboard", sender: self)
                                                    
                                                } else {
                                                    alert.show()
                                                }
                                            })
                                        }
                                    } else {
                                        let alert = UIAlertView(title: "Failed : (", message: "Incorrect username and password", delegate: nil, cancelButtonTitle: "Okay")
                                        alert.show()
                                    }
                                }
                                else {
                                    //self.showAlertController("Touch ID Authentication Failed")
                                }
                            })
                    })
                }
            }
        } else {
            let alert = UIAlertView(title: "Please Register for FIOD", message: "This user account is not registered for FIDO UAF, or the application was upgraded and re-registration is required.  Please sign in with your Username and Password and re-register for FIDO UAF.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func LoggedIn(){
        
        self.api = API()
        
        let url = Persistent.endpoint + Persistent.baseroot + "/users/login"
        let username = userTextField.text
        let password = passwordTextField.text
        let paramstring = "username=" + username! + "&password=" + password!
        
        if username != "" {
            api.LogIn(username!, params: paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
                let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay")
                if(succeeded) {
                    self.users = [Users]()
                    
                    let url = Persistent.endpoint + Persistent.baseroot + "/users/" + username!
                    self.api.loadUser(username!, apiUrl: url, completion : self.didLoadUsers)
                    
                    if myLoginId != username {
                        myFIDO = false
                    }
                    let appGroupID = "group.com.persistent.plat-sol.OIGApp"
                    
                    if let defaults = NSUserDefaults(suiteName: appGroupID) {
                        defaults.setValue(username, forKey: "requestorUserId")
                    }
                    
                    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "requestorUserId")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    myLoginId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
                    
                    self.SaveLogin(username!, pwd: password!)
                }
                else {
                    alert.title = "Failed : ("
                    alert.message = msg
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(succeeded)
                    {
                        self.performSegueWithIdentifier("SegueDashboard", sender: self)
                        
                    } else {
                        alert.show()
                    }
                })
            }
        } else {
            let alert = UIAlertView(title: "Failed : (", message: "Incorrect username and password", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func didLoadUsers(loadedUsers: [Users]){
        for usr in loadedUsers {
            users.append(usr)
            
            NSUserDefaults.standardUserDefaults().setObject(usr.DisplayName, forKey: "DisplayName")
            NSUserDefaults.standardUserDefaults().setObject(usr.Title, forKey: "Title")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }

    func SaveLogin (usr: String, pwd: String) {
        let file = "userlogin.txt"
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] as NSString!
            let path = dir.stringByAppendingPathComponent(file);
            let text = usr + "," + pwd
            
            do {
                try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            } catch {
            }
        }
    }
    
    func ReadLogin() -> Bool {
        let file = "userlogin.txt"
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) {
            let dir = dirs[0] as NSString!
            let path = dir.stringByAppendingPathComponent(file);
            let text = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            
            if text != nil {
                
                let loginInfo: String = text!
                let loginInfoArray = loginInfo.componentsSeparatedByString(",")
                
                let username: String = loginInfoArray[0]
                let password: String = loginInfoArray[1]
                
                FIDOusername = username
                FIDOpassword = password
                
                return true
            } else {
                return false
            }
        }
        return false
    }
}
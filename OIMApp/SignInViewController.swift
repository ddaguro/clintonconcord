//
//  SignInViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/7/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation
import UIKit

class SignInViewController : UIViewController {
    
    @IBOutlet var titleLabel : UILabel!
    
    @IBOutlet var facebookButton : UIButton!
    @IBOutlet var twitterButton : UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bgImageView.image = UIImage(named: "login-bg")
        bgImageView.contentMode = .ScaleAspectFill
        
        
        //titleLabel.text = "Sign In"
        //titleLabel.font = UIFont(name: MegaTheme.semiBoldFontName, size: 45)
        //titleLabel.textColor = UIColor.whiteColor()
        
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        signInButton.layer.borderWidth = 3
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.cornerRadius = 5
        signInButton.addTarget(self, action: "LoggedIn", forControlEvents: .TouchUpInside)
        
        forgotPassword.setTitle("Forgot Password?", forState: .Normal)
        forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        forgotPassword.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        forgotPassword.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        passwordContainer.backgroundColor = UIColor.clearColor()
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordLabel.textColor = UIColor.whiteColor()
        
        passwordTextField.text = "Oracle123"
        passwordTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.secureTextEntry = true
        
        userContainer.backgroundColor = UIColor.clearColor()
        
        userLabel.text = "Username"
        userLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        userLabel.textColor = UIColor.whiteColor()
        
        userTextField.text = "dcrane"
        userTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        userTextField.textColor = UIColor.whiteColor()
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact
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
    
    func LoggedIn(){
        
        self.api = API()
        
        let url = Persistent.endpoint + "/webapp/rest/identity/login"
        
        let username = userTextField.text
        let password = passwordTextField.text
        let paramstring = "username=" + username + "&password=" + password
        
        api.LogIn(paramstring, url : url) { (succeeded: Bool, msg: String) -> () in
            var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            if(succeeded) {
                alert.title = "Success!"
                alert.message = msg
                
                //load user object
                self.users = [Users]()
                
                let url = Persistent.endpoint + "/webapp/rest/identity/" + username + "/" + username
                self.api.loadUser(url, completion : self.didLoadUsers)
                
                NSUserDefaults.standardUserDefaults().setObject(username, forKey: "requestorUserId")
                NSUserDefaults.standardUserDefaults().setObject(username, forKey: "searchUserId")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            else {
                alert.title = "Failed : ("
                alert.message = msg
            }
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(succeeded)
                {
                    self.performSegueWithIdentifier("dashboardNav", sender: self)
                } else {
                    alert.show()
                }
            })
        }
    }
    
    func didLoadUsers(loadedUsers: [Users]){
        for usr in loadedUsers {
            users.append(usr)
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NavigationTableCell", forIndexPath: indexPath) as! UITableViewCell
        return cell
    }

}


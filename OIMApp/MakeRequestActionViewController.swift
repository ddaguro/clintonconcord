//
//  MakeRequestActionViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 7/2/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class MakeRequestActionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBAction func goBack(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    var displayName : String!
    var appInstanceKey : Int!
    var catalogId: String!
    
    var api : API!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.clipsToBounds = true
        titleLabel.text = displayName
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        
        self.api = API()
        
        //---> Adding Swipe Gesture
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

    }
    
    // MARK: swipe gestures
    func rightSwiped()
    {
        println("right swiped ")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func leftSwiped()
    {
        println("left swiped ")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestActionCell") as! RequestActionCell
        
        cell.titleLabel.text = displayName
        cell.descriptionLabel.text = "aid: " + "\(appInstanceKey)" + " cid: " + catalogId
        
        cell.addButton.setBackgroundImage(UIImage(named:"btn-certify"), forState: .Normal)
        cell.addButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        
        cell.cancelButton.setBackgroundImage(UIImage(named:"btn-revoke"), forState: .Normal)
        cell.cancelButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
            
        cell.moreButton.setBackgroundImage(UIImage(named:"btn-more"), forState: .Normal)
        cell.moreButton.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func buttonAction(sender:UIButton!)
    {
        var btnsendtag:UIButton = sender
        let action = sender.currentTitle
        
        let comments = "" as String!
        
        var alerttitle : String!
        var alertmsg : String!
        
        if action == "Add" {
            
            alerttitle = "Certify Confirmation"
            alertmsg = "Please confirm approval for "
            
        } else if action == "Cancel" {
            
            alerttitle = "Revoke Confirmation"
            alertmsg = "Please confirm rejection of "
            
        } else if action == "More" {
            
            alerttitle = ""
            alertmsg = ""
        }
        
        var doalert : DOAlertController
        
        if action != "More" {
            
            doalert = DOAlertController(title: alerttitle, message: alertmsg, preferredStyle: .Alert)
            
            doalert.addTextFieldWithConfigurationHandler { textField in
                
            }
            
            let certifyAction = DOAlertAction(title: "OK", style: .Default) { action in
                let textField = doalert.textFields![0] as! UITextField
                //PERFORM APPROVAL THRU API
                
                var requestorUserId : String!
                requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
                let url = Persistent.endpoint + Persistent.baseroot + "/requests/makeRequest"
                
                var jsonstring = "{\"requester\":{\"User Login\":\"" + requestorUserId + "\"},\"targetUsers\":[{\"User Login\":\"" + requestorUserId
                jsonstring += "\"}],\"accounts\":[{\"entitlements\":[{\"entitlementKey\":\"" + "\(self.appInstanceKey)"  + "\",\"catalogId\":\"" + self.catalogId + "\"}]}]}"
                
                self.api.RequestAction(jsonstring, url : url) { (succeeded: Bool, msg: String) -> () in
                    var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay")
                    if(succeeded) {
                        alert.title = "Success!"
                        alert.message = msg
                        
                    }
                    else {
                        alert.title = "Failed : ("
                        alert.message = msg
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    })
                }
            }
            let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            doalert.addAction(cancelAction)
            doalert.addAction(certifyAction)
            
            presentViewController(doalert, animated: true, completion: nil)
        } else {
            doalert = DOAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let editAction = DOAlertAction(title: "Edit ", style: .Destructive) { action in
            }
            let cancelAction = DOAlertAction(title: "Cancel", style: .Cancel) { action in
            }
            doalert.addAction(editAction)
            doalert.addAction(cancelAction)
            
            presentViewController(doalert, animated: true, completion: nil)
        }
    }

}

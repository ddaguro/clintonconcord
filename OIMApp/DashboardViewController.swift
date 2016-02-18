//
//  DashboardViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/19/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit
import LocalAuthentication

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var colorValues : [UIColor]?
    var arcSize : Double?
    
    @IBOutlet var dashView: UIView!
    var nagivationStyleToPresent : String?
    
    @IBOutlet weak var lblTotalCounts: UILabel!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var recentActivityLabel: UILabel!
    var users : [Users]!
    var activities : [Activities]!
    var api : API!
    
    let transitionOperator = TransitionOperator()
    var refreshControl:UIRefreshControl!
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("----->>> DashboardViewController")
        
        if myFIDO == false {
            showAlert()
        }
        
        menuItem.image = UIImage(named: "menu")
        toolbar.clipsToBounds = true
        labelTitle.text = "Dashboard"
        tableView.delegate = self
        tableView.dataSource = self
        
        getPendingCounts(myLoginId)

        var requestorUserId : String!
        requestorUserId = NSUserDefaults.standardUserDefaults().objectForKey("requestorUserId") as! String
        myRequestorId = requestorUserId

        self.users = [Users]()
        self.activities = [Activities]()
        self.api = API()
        
        //let url = myAPIEndpoint + "/users/" + requestorUserId
        //api.loadUser(requestorUserId, apiUrl: url, completion : didLoadUsers)
        
        
        //let url2 = myAPIEndpoint + "/users/" + myLoginId + "/recentactivity?limit=10"
        let url2 = myAPIEndpoint + "/users/" + myLoginId + "/requests?limit=10&filter=reqCreationDate%20ge%202016-01-01"
        api.loadActivities(myLoginId, apiUrl: url2, completion : didLoadActivities)
        /*
        if myActivities.count == 0 {
            println("load from api")
            api.loadActivities(myLoginId, apiUrl: url2, completion : didLoadActivities)
        } else {
            println("load from storage")
        }
        */
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.redColor()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        //---> PanGestureRecognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        self.view.addGestureRecognizer(recognizer)

    }
    
    func refresh(){
        
        let url2 = myAPIEndpoint + "/users/" + myLoginId + "/requests?limit=10&filter=reqCreationDate%20ge%202016-01-01"
        api.loadActivities(myLoginId, apiUrl: url2, completion : didLoadActivities)
        
        SoundPlayer.play("upvote.wav")
    }
    
    func showAlert(){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        createAccountErrorAlert.delegate = self
        createAccountErrorAlert.title = ""
        createAccountErrorAlert.message = "Would you like to register for FIDO biometric authentication?"
        createAccountErrorAlert.addButtonWithTitle("Cancel")
        createAccountErrorAlert.addButtonWithTitle("OK")
        createAccountErrorAlert.show()
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
        case 0:
            //NSLog("Cancel");
            break;
        case 1:
            //NSLog("OK");
            let context = LAContext()
            var error: NSError?
            
            // check if Touch ID is available
            if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate with Touch ID"
                context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                    {(succes: Bool, error: NSError?) in
                        dispatch_async(dispatch_get_main_queue(), {
                            
                        if succes {
                            myFIDO = true
                            let alert = UIAlertView(title: "Success \u{1F44D}", message: "FIDO UAF Authentication Succeeded", delegate: nil, cancelButtonTitle: "Okay")
                            alert.show()
                        }
                        else {
                            self.showAlertController("Touch ID Authentication Failed")
                        }
                    })
                })
            }
            break;
        default:
            NSLog("Default");
            break;
        }
    }
    
    func showAlertController(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func appBtnTouched(sender:UIButton!) {
        let btnsendtag:UIButton = sender
        if btnsendtag.tag == 1 {
            //println("Button tapped pending approvals")
            self.performSegueWithIdentifier("SegueApprovals", sender: self)
        }
    }
    func reqBtnTouched(sender:UIButton!) {
        let btnsendtag:UIButton = sender
        if btnsendtag.tag == 2 {
            //println("Button tapped pending requests")
            self.performSegueWithIdentifier("SegueRequests", sender: self)
        }
    }
    func certBtnTouched(sender:UIButton!) {
        let btnsendtag:UIButton = sender
        if btnsendtag.tag == 3 {
            //println("Button tapped pending certifications")
            self.performSegueWithIdentifier("SegueCerts", sender: self)
        }
    }
    // MARK: swipe gestures
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.panGestureRecognized(sender)
    }

    /*
    func didLoadUsers(loadedUsers: [Users]){
        
        for usr in loadedUsers {
            self.users.append(usr)
        }
        tableView.reloadData()
    }
    */
    
    func didLoadActivities(loadedActivities: [Activities]){
        self.activities = [Activities]()
        
        for act in loadedActivities {
            self.activities.append(act)
        }
        activities.sortInPlace({ $0.reqModifiedOnDate > $1.reqModifiedOnDate })
        tableView.reloadData()
        view.hideLoading()
        
        if isFirstTime  {
            self.view.showLoading()
        }
        self.tableView.reloadData()
        self.view.hideLoading()
        self.refreshControl?.endRefreshing()
    }

    
    func getPendingCounts(requestorUserId: String) {
        
        view.showDashLoading()
        self.lblTotalCounts.layer.cornerRadius = 9;
        lblTotalCounts.layer.masksToBounds = true;
        
        arcSize = degreesToRadians(360)
        let arcStart = 3/4 * M_PI
        let arcEnd = 3 * M_PI
        
        api = API()
        
        let url = myAPIEndpoint + "/users/" + requestorUserId + "/pendingoperationscount"
        api.getDashboardCount(myLoginId, apiUrl: url, completion: { (success) -> () in
            
            // --> Total Pending
            totalCounter = (myCertificates + myApprovals + myRequest)
            if (totalCounter > 0) {
                self.lblTotalCounts.hidden = false
                self.lblTotalCounts.layer.cornerRadius = 9
                self.lblTotalCounts.layer.masksToBounds = true
                self.lblTotalCounts.text = "\(totalCounter)"
            } else {
                self.lblTotalCounts.hidden = true
            }
            
            // --> Chart Pending Approvals
            let apptotcnt = myApprovals ==  0  ? 0 : myApprovals + totalCounter/2
            let arcValues = [apptotcnt,0,totalCounter]
            let appradius = 90.0
            let appCenter = CGPointMake(CGFloat(self.screenSize.width/2.0), CGFloat(85.0))
            self.createArc(appCenter, radius: appradius, startAngle: arcStart, endAngle: arcEnd, color: self.UIColorFromHex(0xeeeeee, alpha: 1.0).CGColor)
            self.animateArcs(arcValues, radius: appradius, center: appCenter, color: self.UIColorFromHex(0x9777a8, alpha: 1.0).CGColor)
            
            let appcntlabel = UILabel(frame: CGRectMake(0, 0, 200, 200))
            appcntlabel.center = CGPointMake(CGFloat(self.screenSize.width/2.0) , CGFloat(85.0))
            appcntlabel.textAlignment = NSTextAlignment.Center
            appcntlabel.font = UIFont(name: MegaTheme.fontName, size: 40)
            appcntlabel.textColor = self.UIColorFromHex(0xa6afaa, alpha: 1.0)
            appcntlabel.text = "\(myApprovals)"
            self.dashView.addSubview(appcntlabel)
            
            let applabel = UILabel(frame: CGRectMake(0, 0, 200, 200))
            applabel.center = CGPointMake(CGFloat(self.screenSize.width/2.0) , CGFloat(120.0))
            applabel.textAlignment = NSTextAlignment.Center
            applabel.font = UIFont(name: MegaTheme.fontName, size: 12)
            applabel.textColor = self.UIColorFromHex(0xa6afaa, alpha: 1.0)
            applabel.numberOfLines = 2
            applabel.text = "PENDING\nAPPROVALS"
            self.dashView.addSubview(applabel)
            
            let appButton = UIButton(type: UIButtonType.System)
            appButton.frame = CGRectMake(0, 0, 200, 200)
            appButton.center = CGPointMake(CGFloat(self.screenSize.width/2.0) , CGFloat(85.0))
            appButton.addTarget(self, action: "appBtnTouched:", forControlEvents: UIControlEvents.TouchUpInside)
            appButton.tag = 1
            self.dashView.addSubview(appButton)
            
            // --> Chart Pending Requests
            let reqtotcnt = myRequest ==  0  ? 0 : myRequest + totalCounter/2
            let arcValues2 = [reqtotcnt,10,totalCounter]
            let reqradius = 50.0
            let reqCenter = CGPointMake(CGFloat(self.screenSize.width/2.0) - CGFloat(75.0) , CGFloat(260.0))
            self.createArc(reqCenter, radius: reqradius, startAngle: arcStart, endAngle: arcEnd, color: self.UIColorFromHex(0xeeeeee, alpha: 1.0).CGColor)
            self.animateArcs(arcValues2, radius: reqradius, center: reqCenter, color: self.UIColorFromHex(0x4a90e2, alpha: 1.0).CGColor)
            
            let reqcntlabel = UILabel(frame: CGRectMake(0, 0, 200, 200))
            reqcntlabel.center = CGPointMake(CGFloat(self.screenSize.width/2.0) - CGFloat(75.0) , CGFloat(260.0))
            reqcntlabel.textAlignment = NSTextAlignment.Center
            reqcntlabel.font = UIFont(name: MegaTheme.fontName, size: 30)
            reqcntlabel.textColor = self.UIColorFromHex(0xa6afaa, alpha: 1.0)
            reqcntlabel.text = "\(myRequest)"
            self.dashView.addSubview(reqcntlabel)
            
            let reqlabel = UILabel(frame: CGRectMake(0, 0, 200, 200))
            reqlabel.center = CGPointMake(CGFloat(self.screenSize.width/2.0) - CGFloat(75.0) , CGFloat(340.0))
            reqlabel.textAlignment = NSTextAlignment.Center
            reqlabel.font = UIFont(name: MegaTheme.fontName, size: 12)
            reqlabel.textColor = self.UIColorFromHex(0xa6afaa, alpha: 1.0)
            reqlabel.numberOfLines = 2
            reqlabel.text = "PENDING\nREQUESTS"
            self.dashView.addSubview(reqlabel)
            
            let reqButton = UIButton(type: UIButtonType.System)
            reqButton.frame = CGRectMake(0, 0, 100, 100)
            reqButton.center = CGPointMake(CGFloat(self.screenSize.width/2.0) - CGFloat(75.0) , CGFloat(260.0))
            reqButton.addTarget(self, action: "reqBtnTouched:", forControlEvents: UIControlEvents.TouchUpInside)
            reqButton.tag = 2
            self.tableView.addSubview(reqButton)
            
            // --> Chart Pending Certfications
            let certtotcnt = myCertificates ==  0  ? 0 : myCertificates + totalCounter/2
            let arcValues3 = [certtotcnt,10,totalCounter]
            let certradius = 50.0
            let certCenter = CGPointMake(CGFloat(self.screenSize.width/2.0) + CGFloat(75.0) , CGFloat(260.0))
            self.createArc(certCenter, radius: certradius, startAngle: arcStart, endAngle: arcEnd, color: self.UIColorFromHex(0xeeeeee, alpha: 1.0).CGColor)
            self.animateArcs(arcValues3, radius: certradius, center: certCenter,color: self.UIColorFromHex(0x88c057, alpha: 1.0).CGColor)
        
            let certcntlabel = UILabel(frame: CGRectMake(0, 0, 200, 200))
            certcntlabel.center = CGPointMake(CGFloat(self.screenSize.width/2.0) + CGFloat(75.0) , CGFloat(260.0))
            certcntlabel.textAlignment = NSTextAlignment.Center
            certcntlabel.font = UIFont(name: MegaTheme.fontName, size: 30)
            certcntlabel.textColor = self.UIColorFromHex(0xa6afaa, alpha: 1.0)
            certcntlabel.text = "\(myCertificates)"
            self.dashView.addSubview(certcntlabel)
            
            let certlabel = UILabel(frame: CGRectMake(0, 0, 200, 200))
            certlabel.center = CGPointMake(CGFloat(self.screenSize.width/2.0) + CGFloat(75.0) , CGFloat(340.0))
            certlabel.textAlignment = NSTextAlignment.Center
            certlabel.font = UIFont(name: MegaTheme.fontName, size: 12)
            certlabel.textColor = self.UIColorFromHex(0xa6afaa, alpha: 1.0)
            certlabel.numberOfLines = 2
            certlabel.text = "PENDING\nCERTIFICATIONS"
            self.dashView.addSubview(certlabel)
            
            let certButton = UIButton(type: UIButtonType.System)
            certButton.frame = CGRectMake(0, 0, 100, 100)
            certButton.center = CGPointMake(CGFloat(self.screenSize.width/2.0) + CGFloat(75.0) , CGFloat(260.0))
            certButton.addTarget(self, action: "certBtnTouched:", forControlEvents: UIControlEvents.TouchUpInside)
            certButton.tag = 3
            self.dashView.addSubview(certButton)
            
            let lblHeading : UILabel! = UILabel(frame: CGRectMake(0, CGFloat(360.0), self.view.frame.size.width, 30))
            lblHeading.backgroundColor = UIColor(red: 236.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1)
            //lblHeading.layer.borderWidth = 1
            //lblHeading.layer.borderColor = UIColor.lightGrayColor().CGColor
            lblHeading.font = UIFont.systemFontOfSize(12)
            lblHeading.textColor = UIColor.darkGrayColor()
            lblHeading.text = "   Recent Activity"
            
            self.dashView.addSubview(lblHeading)
            
            // --> Recent Activity
            /*
            let recentimage = UIImage(named: "recentactivity")
            let recentimageView = UIImageView(image: recentimage!)
            recentimageView.frame = CGRect(x: 0, y: CGFloat(self.screenSize.height/2.0) + CGFloat(380.0), width: self.screenSize.width, height: self.screenSize.height)
            recentimageView.contentMode = UIViewContentMode.ScaleAspectFill
            self.tableView.addSubview(recentimageView)
            */
            

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return users.count;
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DashboardCell") as! DashboardCell

        let info = activities[indexPath.row]
        
        if info.requester.lowercaseString == "kevin clark" {
            cell.profileImage.image = UIImage(named: "kclark")
        } else if info.requester.lowercaseString == "grace davis" {
            cell.profileImage.image = UIImage(named: "gdavis")
        } else if info.requester.lowercaseString == "danny crane" {
            cell.profileImage.image = UIImage(named: "dcrane")
        } else {
            cell.profileImage.image = UIImage(named: "profileBlankPic")
        }
        
        //cell.profileImage.image = UIImage(named: "dcrane")
        
        var titleText = ""
        for ent in info.reqTargetEntities {
            if titleText.isEmpty {
                titleText = ent.entityname
            } else {
                titleText += " , \(ent.entityname)"
            }
        }
        cell.titleLabel.text = titleText
        //cell.titleLabel.adjustsFontSizeToFitWidth = true
        //cell.statusImage.image = info.reqStatus == "Request Completed" ? UIImage(named: "badge-new") : UIImage(named: "Badge-Assigned")
        cell.statusLabel.text = "  " + info.reqStatus.stringByReplacingOccurrencesOfString("Request ", withString: "") + "  "
        
        var statuscolor : UIColor
        
        switch info.reqStatus {
            
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
        default:
            statuscolor = self.UIColorFromHex(0x546979, alpha: 1.0)
            break;
        }
        cell.statusLabel.backgroundColor = statuscolor
        
        
        //cell.statusLabel.adjustsFontSizeToFitWidth = true
        //cell.subtitleLabel.text = "Request ID " + info.reqId
        cell.assigneeHeadingLabel.text = "Assignees"
        
        var assigneeText = ""
        for assign in info.reqBeneficiaryList {
            if assigneeText.isEmpty {
                assigneeText = assign.beneficiary
            } else {
                assigneeText += " , \(assign.beneficiary)"
            }
        }
        
        cell.assigneeLabel.text = assigneeText
        cell.dateLabel.text = info.reqModifiedOnDate
        /*
        var approverText = ""
        for approve in info.currentApprovers {
            if approverText.isEmpty {
                approverText = approve.approvers
            }
        }
        */
        cell.descriptionLabel.text = " ID: " + info.reqId + " | Type: " + info.reqType
        
        //let info = users[indexPath.row]
        //cell.titleLabel.text = info.DisplayName
        //cell.subtitleLabel.text = info.Email
        //NSUserDefaults.standardUserDefaults().setObject(info.DisplayName, forKey: "DisplayName")
        //NSUserDefaults.standardUserDefaults().setObject(info.Title, forKey: "Title")
        //NSUserDefaults.standardUserDefaults().synchronize()
        
        return cell;
    }

    @IBAction func presentNavigation(sender: AnyObject) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController 
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
        toViewController.transitioningDelegate = self.transitionOperator

    }
    
    /* Circle Chart */
    func animateArcs(arcValues:Array<Int>, radius: Double, center: CGPoint, color: CGColor) {
        let sum = arcValues.reduce(0,combine: +)
        var currentOffset = 0
        var currentStartAngle : Double?
        var currentEndAngle : Double?
        var currentDelay : Double = 0
        
        for var i = 0; i < arcValues.count; i++ {
            let duration = Double(CGFloat(arcValues[i])/CGFloat(sum))
            
            if currentEndAngle == nil {
                currentStartAngle = degreesToRadians(120)
            } else {
                currentStartAngle = currentEndAngle
            }
            
            if (CGFloat(self.arcSize!) * CGFloat(duration) + CGFloat(currentStartAngle!)) > CGFloat(M_PI*2) {
                currentEndAngle = Double((CGFloat(self.arcSize!) * CGFloat(duration) + CGFloat(currentStartAngle!)) - CGFloat(M_PI*2))
            } else {
                currentEndAngle = Double((CGFloat(self.arcSize!) * CGFloat(duration) + CGFloat(currentStartAngle!)))
            }
            
            var currentDelaySeconds = currentDelay as Double
            
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(currentDelay * Double(NSEC_PER_SEC)))
            var currentColor : CGColor?
            if i % 2 == 0 {
                currentColor = color
            } else {
                currentColor = UIColor.redColor().CGColor
            }
            
            self.createAnimatedArc(center, radius: radius, startAngle: currentStartAngle!, endAngle: currentEndAngle!, color: currentColor!, duration: duration, beginTime: currentDelay, z: CGFloat(-1 * i))
            
            currentDelay += duration
        }
    }
    
    func createArc(center: CGPoint, radius: Double, startAngle : Double, endAngle : Double, color : CGColor) {
        
        let arc = CAShapeLayer()
        arc.lineCap = kCALineCapRound
        //arc.zPosition = -1000
        
        arc.path = UIBezierPath(arcCenter: center, radius:
            CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
        
        arc.fillColor = UIColor.whiteColor().CGColor
        arc.strokeColor = color
        arc.lineWidth = 14
        arc.strokeEnd = CGFloat(2.5 * M_PI)
        
        self.dashView.layer.addSublayer(arc)
    }
    
    func createAnimatedArc(center: CGPoint, radius: Double, startAngle : Double, endAngle : Double, color : CGColor, duration: Double, beginTime: Double, z: CGFloat) {
        
        let arc = CAShapeLayer()
        arc.zPosition = z
        arc.path = UIBezierPath(arcCenter: center, radius:
            CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
        
        arc.fillColor = UIColor.clearColor().CGColor
        arc.strokeColor = color
        arc.lineCap = kCALineCapRound
        
        arc.lineWidth = 14
        
        var originalStrokeEnd = 0
        
        arc.strokeStart = 0
        arc.strokeEnd = 0
        
        let arcAnimation = CABasicAnimation(keyPath:"strokeEnd")
        arcAnimation.fromValue = NSNumber(double: 0)
        arcAnimation.toValue = NSNumber(double: 1)
        
        arcAnimation.duration = duration
        arcAnimation.beginTime = CFTimeInterval(CACurrentMediaTime() + beginTime)
        arcAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        arc.addAnimation(arcAnimation, forKey: "drawCircleAnimation")
        self.dashView.layer.addSublayer(arc)
        
        let delay = (duration + beginTime - 0.07) * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            let finalArc = CAShapeLayer()
            finalArc.zPosition = z
            finalArc.lineCap = kCALineCapRound
            finalArc.path = UIBezierPath(arcCenter: center, radius:
                CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
            
            finalArc.fillColor = UIColor.clearColor().CGColor
            finalArc.strokeColor = color
            finalArc.lineWidth = 14
            
            var originalStrokeEnd = 0
            
            finalArc.strokeStart = 0
            finalArc.strokeEnd = 1
            self.dashView.layer.addSublayer(finalArc)
        })
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees / 180.0 * M_PI
    }
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * (180.0 / M_PI)
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}

//
//  API.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class API {
    
    // swift 2.0 - ACCESS VIEWCONTROLLER *
    func loadApplications(loginId: String, apiUrl: String, completion: (([Applications]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["userAccounts"]!["userAppInstances"] as! NSArray
                
                var apps = [Applications]()
                for app in results{
                    let app = Applications(data: app as! NSDictionary)
                    apps.append(app)
                }
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(apps)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - ACCESS VIEWCONTROLLER *
    func loadEntitlements(loginId: String, apiUrl: String, completion: (([Entitlements]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["userAccounts"]!["userEntitlements"] as! NSArray
                
                var entitles = [Entitlements]()
                for entitle in results{
                    let entitle = Entitlements(data: entitle as! NSDictionary)
                    entitles.append(entitle)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(entitles)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - ACCESS VIEWCONTROLLER *
    func loadRoles(loginId: String, apiUrl: String, completion: (([Roles]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["userAccounts"]!["userRoles"] as! NSArray
                
                var roles = [Roles]()
                for role in results{
                    let role = Roles(data: role as! NSDictionary)
                    roles.append(role)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(roles)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - SIGNIN VIEWCONTROLLER *
    func LogIn(loginId: String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                if let parseJSON = json {
                    let success = parseJSON["isAuthenticated"] as? Int
                    if success == 1 {
                        postCompleted(succeeded: true, msg: "Successful")
                    } else {
                        postCompleted(succeeded: false, msg: "Incorrect username and password")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - MENU VIEWCONTROLLER *
    func LogOut(loginId: String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                if let parseJSON = json {
                    let success = parseJSON["isAuthenticated"] as? Int
                    if success == 0 {
                        postCompleted(succeeded: true, msg: "Logged out.")
                    } else {
                        postCompleted(succeeded: false, msg: "Logged out error.")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - DASHBOARD VIEWCONTROLLER *
    func loadUser(loginId: String, apiUrl: String, completion: (([Users]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["Users"] as! NSArray
                
                var users = [Users]()
                for user in results{
                    let user = Users(data: user as! NSDictionary)
                    users.append(user)
                }
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(users)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - APPROVALS VIEWCONTROLLER *
    func loadPendingApprovals(loginId: String, apiUrl: String, completion: (([Tasks]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["task"] as! NSArray
                
                var tasks = [Tasks]()
                for task in results{
                    let task = Tasks(data: task as! NSDictionary)
                    tasks.append(task)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(tasks)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - REQUESTS VIEWCONTROLLER *
    func loadRequests(loginId: String, apiUrl: String, completion: (([Requests]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["requests"] as! NSArray
                
                var reqs = [Requests]()
                for req in results{
                    let req = Requests(data: req as! NSDictionary)
                    reqs.append(req)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(reqs)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - APPROVALS VIEWCONTROLLER *
    func RequestApprovalAction(loginId : String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                if let parseJSON = json {
                    let info : NSArray =  parseJSON.valueForKey("results") as! NSArray
                    let success: Bool? = info[0].valueForKey("isSuccess") as? Bool
                    
                    if success == true {
                        postCompleted(succeeded: true, msg: "Approved Request")
                    } else {
                        postCompleted(succeeded: false, msg: "Approved Request Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION VIEWCONTROLLER
    func loadPendingCerts(loginId: String, apiUrl: String, completion: (([Certs]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                var certs = [Certs]()
                
                if jsonData["count"] as! NSNumber != 0 {
                    let results: NSArray = jsonData["identityCertifications"]!["certificationInstances"] as! NSArray
                    
                    for cert in results{
                        let cert = Certs(data: cert as! NSDictionary)
                        certs.append(cert)
                    }
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(certs)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION DETAIL VIEWCONTROLLER APPLICATIONS
    func loadCertItem(loginId: String, apiUrl: String, completion: (([CertItem]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["certificationLineItems"] as! NSArray
                
                var certs = [CertItem]()
                for cert in results{
                    let cert = CertItem(data: cert as! NSDictionary)
                    certs.append(cert)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(certs)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTFICATION DETAIL ITEMS VIEWCONTROLLER APPLICATONS
    func loadCertItemDetails(loginId: String, apiUrl: String, completion: (([CertItemDetail]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["accounts"]  as! NSArray
                
                var certs = [CertItemDetail]()
                for cert in results{
                    let cert = CertItemDetail(data: cert as! NSDictionary)
                    certs.append(cert)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(certs)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION DETAIL VIEWCONTROLLER ENTITLEMENTS
    func loadEntItem(loginId: String, apiUrl: String, completion: (([EntitlementItem]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["entitlementCertificationLineItems"] as! NSArray
                
                var ents = [EntitlementItem]()
                for ent in results{
                    let ent = EntitlementItem(data: ent as! NSDictionary)
                    ents.append(ent)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(ents)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTFICIATION DETAIL ITEMS VIEWCONTROLLER ENTITLEMENTS
    func loadCertEntItemDetails(loginId: String, apiUrl: String, completion: (([EntitlementItemDetail]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["entitlementCertLineItemDetails"]  as! NSArray
                
                var ents = [EntitlementItemDetail]()
                for ent in results{
                    let ent = EntitlementItemDetail(data: ent as! NSDictionary)
                    ents.append(ent)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(ents)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION DETAIL VIEWCONTROLLER USERS
    func loadUserItem(loginId: String, apiUrl: String, completion: (([UserItem]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["userCertificationLineItems"] as! NSArray
                
                var users = [UserItem]()
                for usr in results{
                    let usr = UserItem(data: usr as! NSDictionary)
                    users.append(usr)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(users)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION DETAIL ITEMS VIEWCONTROLLER USERS
    func loadCertUserItemDetails(loginId: String, apiUrl: String, completion: (([UserItemDetail]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["accounts"]  as! NSArray
                
                var users = [UserItemDetail]()
                for user in results{
                    let user = UserItemDetail(data: user as! NSDictionary)
                    users.append(user)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(users)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION DETAIL VIEWCONTROLLER ROLES
    func loadRoleItem(loginId: String, apiUrl: String, completion: (([RoleItem]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["roleCertificationLineItems"] as! NSArray
                
                var roles = [RoleItem]()
                for role in results{
                    let role = RoleItem(data: role as! NSDictionary)
                    roles.append(role)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(roles)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION DETAIL ITEMS VIEWCONTROLLER ROLES
    func loadCertRoleItemDetails(loginId: String, apiUrl: String, completion: (([RoleItemDetail]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["roleMembers"]  as! NSArray
                
                var roles = [RoleItemDetail]()
                for role in results{
                    let role = RoleItemDetail(data: role as! NSDictionary)
                    roles.append(role)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(roles)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - CERTIFICATION ACTION VIEWCONTROLLER (APPLICATION ONLY)
    func RequestCertificationsAction(loginId : String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                if let parseJSON = json {
                    let success: Bool? = parseJSON.valueForKey("isSuccess") as? Bool
                    if success == true {
                        postCompleted(succeeded: true, msg: "Approved Certifications")
                    } else {
                        postCompleted(succeeded: false, msg: "Certfication Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - MAKE REQUEST VIEWCONTROLLER *
    func loadAllEntitlements(loginId: String, apiUrl: String, completion: (([Entitlements]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["accounts"]!["entitlements"] as! NSArray
                
                var ents = [Entitlements]()
                for ent in results{
                    let ent = Entitlements(data: ent as! NSDictionary)
                    ents.append(ent)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(ents)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - MAKE REQUEST ACTION VIEWCONTROLLER *
    func RequestAction(loginId : String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                if let parseJSON = json {
                    let success: String? = parseJSON.valueForKey("requestresults") as? String
                    if (success?.rangeOfString("Request Raised") != nil) {
                        postCompleted(succeeded: true, msg: "Success")
                    } else {
                        postCompleted(succeeded: false, msg: "Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
    
    // swift 2.0 - DASHBOARD VIEWCONTROLLER *
    func getDashboardCount(loginId: String, apiUrl: String, completion: ((success: Int) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let cntapp: Int = jsonData["count"]!["approvals"] as! Int
                let cntcert: Int = jsonData["count"]!["certifications"] as! Int
                let cntreq: Int = jsonData["count"]!["requests"] as! Int
                
                myApprovals = cntapp
                myRequest = cntreq
                myCertificates = cntcert
                
                NSUserDefaults.standardUserDefaults().setObject(cntapp, forKey: "dashapp")
                NSUserDefaults.standardUserDefaults().setObject(cntcert, forKey: "dashcert")
                NSUserDefaults.standardUserDefaults().setObject(cntreq, forKey: "dashreq")
                NSUserDefaults.standardUserDefaults().synchronize()
                let results = 1
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(success: results)
                    }
                }
            }
        })
        task.resume()
    }
    
    // swift 2.0 - DASHBOARD VIEWCONTROLLER *
    func loadActivities(loginId: String, apiUrl: String, completion: (([Activities]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue(myClientId, forHTTPHeaderField: "clientId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["recentActivity"]!["recentRequests"] as! NSArray
                
                var reqs = [Activities]()
                for req in results{
                    let req = Activities(data: req as! NSDictionary)
                    reqs.append(req)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(reqs)
                    }
                }
            }
        })
        task.resume()
    }
    
    /*

    NOT BEING USED as of 09/18
    

    
    func loadIdentities(identitiesUrl: String, completion: (([Identity]) -> Void)!) {
        let urlString = identitiesUrl
        let session = NSURLSession.sharedSession()
        let identitiesUrl = NSURL(string: urlString)
        
        let task = session.dataTaskWithURL(identitiesUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let identitiesData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = identitiesData["Users"] as! NSArray
                
                var identities = [Identity]()
                for identity in results{
                    let identity = Identity(data: identity as! NSDictionary)
                    identities.append(identity)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(identities)
                    }
                }
            }
        }
        task.resume()
    }
    
    func loadAccounts(apiUrl: String, completion: (([Accounts]) -> Void)!) {
        let urlString = apiUrl
        let session = NSURLSession.sharedSession()
        let identitiesUrl = NSURL(string: urlString)
        
        let task = session.dataTaskWithURL(identitiesUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let identitiesData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)) as! NSDictionary
                
                let results: NSArray = identitiesData["userAccounts"] as! NSArray
                
                var identities = [Accounts]()
                
                for identity in results{
                    let identity = Accounts(data: identity as! NSDictionary)
                    identities.append(identity)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(identities)
                    }
                }
            }
        }
        task.resume()
    }
    
    func loadAllRoles(loginId: String, apiUrl: String, completion: (([Roles]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let jsonData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = jsonData["accounts"]!["roles"] as! NSArray
                
                var roles = [Roles]()
                for role in results{
                    let role = Roles(data: role as! NSDictionary)
                    roles.append(role)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(roles)
                    }
                }
            }
        })
        task.resume()
    }
    
    func loadAllApplications(loginId: String, apiUrl: String, completion: (([Applications]) -> Void)!) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                let identitiesData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                let results: NSArray = identitiesData["accounts"]!["appInstances"] as! NSArray
                
                var identities = [Applications]()
                for identity in results{
                    let identity = Applications(data: identity as! NSDictionary)
                    identities.append(identity)
                }
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(identities)
                    }
                }
            }
        })
        task.resume()
    }
    
    // not working
    func getDataFromUrl(apiUrl: String, completion: ((data: NSData?) -> Void)) {
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        request.addValue("application/png", forHTTPHeaderField: "Content-Type")
        request.addValue(myLoginId, forHTTPHeaderField: "loginId")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                print(error!.localizedDescription)
            }
            else {
                completion(data: data)
            }
        })
        task.resume()
    }
    */
}
//
//  API.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 5/6/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import Foundation

class API{
    
    func loadIdentities(identitiesUrl: String, completion: (([Identity]) -> Void)!) {
        
        var urlString = identitiesUrl
        
        let session = NSURLSession.sharedSession()
        let identitiesUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(identitiesUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                var error : NSError?
                var identitiesData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
                //let results: NSArray = identitiesData["restaurants"] as! NSArray
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
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let identitiesUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(identitiesUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                var error : NSError?
                var identitiesData = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! NSDictionary
                
                let results: NSArray = identitiesData["userAccounts"] as! NSArray
                
                var identities = [Accounts]()
                
                for identity in results{
                    let identity = Accounts(data: identity as! NSDictionary)
                    identities.append(identity)
                }
                
                /*
                let results2: NSArray = identitiesData["userAccounts"]!["userEntitlements"] as! NSArray
                
                for identity in results2{
                let identity = Accounts(data: identity as! NSDictionary)
                identities.append(identity)
                }
                
                let results3: NSArray = identitiesData["userAccounts"]!["userRoles"] as! NSArray
                
                for identity in results3{
                let identity = Accounts(data: identity as! NSDictionary)
                identities.append(identity)
                }
                */
                
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
    
    // 0713 - point to idaas
    func loadApplications(loginId: String, apiUrl: String, completion: (([Applications]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 - point to idaas
    func loadEntitlements(loginId: String, apiUrl: String, completion: (([Entitlements]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 - point to idaas
    func loadRoles(loginId: String, apiUrl: String, completion: (([Roles]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    //ok
    func LogIn(params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        //let postString = "username=lnguyen&password=Oracle1234";
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    let success = parseJSON["isAuthenticated"] as? Int
                    if success == 1 {
                        //println("Succes: \(success)")
                        postCompleted(succeeded: true, msg: "Successful")
                    } else {
                        //println("Succes: \(success)")
                        postCompleted(succeeded: false, msg: "Incorrect username and password")
                        
                    }
                    return
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
    
    //ok
    func LogOut(loginId: String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    let success = parseJSON["isAuthenticated"] as? Int
                    if success == 0 {
                        //println("Succes: \(success)")
                        postCompleted(succeeded: true, msg: "Logged out.")
                    } else {
                        //println("Succes: \(success)")
                        postCompleted(succeeded: false, msg: "Logged out error.")
                        
                    }
                    return
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
    
    // 0713 point to idaas
    func loadUser(loginId: String, apiUrl: String, completion: (([Users]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadPendingApprovals(loginId: String, apiUrl: String, completion: (([Tasks]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadRequests(loginId: String, apiUrl: String, completion: (([Requests]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"

        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    func RequestApprovalAction(loginId : String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    //let success = parseJSON["approvalActionStatus"] as? String
                    var info : NSArray =  json!.valueForKey("results") as! NSArray
                    var success: Bool? = info[0].valueForKey("isSuccess") as? Bool
                    
                    //let success = "APPROVE"
                    
                    if success == true {
                        /*
                        ·         APPROVE
                        ·         REJECT
                        ·         REASSIGN
                        ·         ESCALATE
                        ·         DELEGATE
                        ·         SUSPEND
                        ·         WITHDRAW
                        ·         CLAIM
                        */
                        //println("Succes: \(success)")
                        postCompleted(succeeded: true, msg: "Approved Request")
                    } else {
                        //println("Succes: \(success)")
                        postCompleted(succeeded: false, msg: "Approved Request Error")
                        
                    }
                    return
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
    
    // 0713 point to idaas
    func loadPendingCerts(loginId: String, apiUrl: String, completion: (([Certs]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadCertItem(loginId: String, apiUrl: String, completion: (([CertItem]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadCertItemDetails(loginId: String, apiUrl: String, completion: (([CertItemDetail]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadEntItem(loginId: String, apiUrl: String, completion: (([EntitlementItem]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadCertEntItemDetails(loginId: String, apiUrl: String, completion: (([EntitlementItemDetail]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    func loadUserItem(loginId: String, apiUrl: String, completion: (([UserItem]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    func loadCertUserItemDetails(loginId: String, apiUrl: String, completion: (([UserItemDetail]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    func loadRoleItem(loginId: String, apiUrl: String, completion: (([RoleItem]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    func loadCertRoleItemDetails(loginId: String, apiUrl: String, completion: (([RoleItemDetail]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func RequestCertificationsAction(loginId : String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                if let parseJSON = json {
                    var success: Bool? = json!.valueForKey("isSuccess") as? Bool
                    
                    if success == true {
                        postCompleted(succeeded: true, msg: "Approved Certifications")
                    } else {
                        postCompleted(succeeded: false, msg: "Certfication Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
    
    // 0713 point to idaas
    func loadAllRoles(loginId: String, apiUrl: String, completion: (([Roles]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadAllApplications(loginId: String, apiUrl: String, completion: (([Applications]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var identitiesData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas
    func loadAllEntitlements(loginId: String, apiUrl: String, completion: (([Entitlements]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 0713 point to idaas - need to handle response
    func RequestAction(loginId : String, params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                if let parseJSON = json {
                    var success: String? = json!.valueForKey("requestresults") as? String
                    
                    if (success?.rangeOfString("Request Raised") != nil) {
                        postCompleted(succeeded: true, msg: "Success")
                    } else {
                        postCompleted(succeeded: false, msg: "Error")
                    }
                    return
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(succeeded: false, msg: "Error")
                }
            }
        })
        
        task.resume()
    }
    
    // 7/13 upadated to idaas
    func getDashboardCount(loginId: String, apiUrl: String, completion: ((success: Int) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
    
    // 7/13 upadated to idaas - not working
    func getDataFromUrl(apiUrl: String, completion: ((data: NSData?) -> Void)) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/png", forHTTPHeaderField: "Content-Type")
        request.addValue(myLoginId, forHTTPHeaderField: "loginId")
        
        //NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
        //    completion(data: data)
        //    }.resume()
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                completion(data: data)
            }
        })
        
        task.resume()
    }
    
    func loadActivities(loginId: String, apiUrl: String, completion: (([Activities]) -> Void)!) {
        var request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(loginId, forHTTPHeaderField: "loginId")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var err: NSError?
            
            if(err != nil) {
                println(err!.localizedDescription)
            }
            else {
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
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
}
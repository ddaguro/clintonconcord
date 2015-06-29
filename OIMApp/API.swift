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
    
    func loadApplications(identitiesUrl: String, completion: (([Applications]) -> Void)!) {
        
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
                
                let results: NSArray = identitiesData["userAccounts"]!["userAppInstances"] as! NSArray
                
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
        }
        
        task.resume()
    }
    
    
    // ok
    func loadEntitlements(apiUrl: String, completion: (([Entitlements]) -> Void)!) {
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let entitleUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(entitleUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
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
        }
        
        task.resume()
    }
    
    // ok
    func loadRoles(apiUrl: String, completion: (([Roles]) -> Void)!) {
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let roleUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(roleUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
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
        }
        
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
                        postCompleted(succeeded: true, msg: "Logged in.")
                    } else {
                        //println("Succes: \(success)")
                        postCompleted(succeeded: false, msg: "Logged in error.")
                        
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
    func LogOut(url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        //request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding);
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
    
    //ok
    func loadUser(apiUrl: String, completion: (([Users]) -> Void)!) {
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let userUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(userUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
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
        }
        
        task.resume()
    }
    
    // 05/26
    
    //ok
    func loadPendingApprovals(apiUrl: String, completion: (([Tasks]) -> Void)!) {
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let sUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(sUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                /*
                if data.length > 0 && error == nil{
                    let html = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("html = \(html)")
                    
                    var newArrayofDicts : NSMutableArray = NSMutableArray()
                    var arrayOfDicts : NSMutableArray? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error:nil) as? NSMutableArray
                    if arrayOfDicts != nil {
                        for item in arrayOfDicts! {
                            if var dict  = item as? NSMutableDictionary{
                                var newDict : NSMutableDictionary = NSMutableDictionary()
                                if dict["taskId"] != nil && dict["taskId"] != nil{
                                    newDict["taskTitle"] = dict["taskTitle"]
                                    newArrayofDicts.addObject(newDict)
                                }
                            }
                        }
                    }
                }
                */
                
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
        }
        
        task.resume()
    }
    
    //ok
    func loadRequests(apiUrl: String, completion: (([Requests]) -> Void)!) {
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let sUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(sUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
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
        }
        
        task.resume()
    }
    
    func RequestApprovalAction(params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
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
    
    // ok 06/18
    func loadPendingCerts(apiUrl: String, completion: (([Certs]) -> Void)!) {
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let sUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(sUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["certificationInstances"] as! NSArray
                
                var certs = [Certs]()
                for cert in results{
                    let cert = Certs(data: cert as! NSDictionary)
                    certs.append(cert)
                }
                
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(certs)
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    // ok 06/18
    func loadCertItem(apiUrl: String, completion: (([CertItem]) -> Void)!) {
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let sUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(sUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
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
        }
        
        task.resume()
    }
    
    // ok 06/19
    func loadCertItemDetails(apiUrl: String, completion: (([CertItemDetail]) -> Void)!) {
        
        var urlString = apiUrl
        
        let session = NSURLSession.sharedSession()
        let sUrl = NSURL(string: urlString)
        
        var task = session.dataTaskWithURL(sUrl!){
            (data, response, error) -> Void in
            
            if error != nil {
                println(error.localizedDescription)
            } else {
                
                var error : NSError?
                var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
                
                let results: NSArray = jsonData["identityCertifications"]!["certificationLineItemDetails"]  as! NSArray
                
                
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
        }
        
        task.resume()
    }
    
    func RequestCertificationsAction(params : String, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
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

}
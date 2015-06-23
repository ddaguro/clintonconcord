//
//  WebViewController.swift
//  OIMApp
//
//  Created by Linh NGUYEN on 6/23/15.
//  Copyright (c) 2015 Persistent Systems. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var url: String!
    @IBOutlet weak var progressView: UIProgressView!
    var hasFinishedLoading = false
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
        showViewController(controller, sender: self)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let targetURL = NSURL(string: "http://ec2-52-25-57-202.us-west-2.compute.amazonaws.com:9080/swagger/v2/dist")
        let request = NSURLRequest(URL: targetURL!)
        webView.loadRequest(request)
        
        webView.delegate = self
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        hasFinishedLoading = false
        updateProgress()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        delay(1) { [weak self] in
            if let _self = self {
                _self.hasFinishedLoading = true
            }
        }
    }
    
    deinit {
        webView.stopLoading()
        webView.delegate = nil
    }
    
    func updateProgress() {
        if progressView.progress >= 1 {
            progressView.hidden = true
        } else {
            
            if hasFinishedLoading {
                progressView.progress += 0.002
            } else {
                if progressView.progress <= 0.3 {
                    progressView.progress += 0.004
                } else if progressView.progress <= 0.6 {
                    progressView.progress += 0.002
                } else if progressView.progress <= 0.9 {
                    progressView.progress += 0.001
                } else if progressView.progress <= 0.94 {
                    progressView.progress += 0.0001
                } else {
                    progressView.progress = 0.9401
                }
            }
            
            delay(0.008) { [weak self] in
                if let _self = self {
                    _self.updateProgress()
                }
            }
        }
    }
    
}

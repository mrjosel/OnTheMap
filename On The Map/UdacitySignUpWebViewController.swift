//
//  UdacitySignUpWebViewController.swift
//  On The Map
//
//  Created by Brian Josel on 7/8/15.
//  Copyright (c) 2015 Brian Josel. All rights reserved.
//

import UIKit

class UdacitySignUpWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var urlRequest: NSURLRequest? = nil
    var completionHandler : ((success: Bool, error: NSError?) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate
        webView.delegate = self
        
        //add nav items
        self.navigationItem.title = "Udacity Sign-Up"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelSignUp")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if urlRequest != nil {
            //load request if successfully passed from LoginVC
            self.webView.loadRequest(urlRequest!)
        }
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //if success URL request retrieved, dismiss view
        println(webView.request!.URL!.absoluteString!   )
        if(webView.request!.URL!.absoluteString! == "\(UdacityClient.Constants.BASE_URL)\(UdacityClient.Constants.SIGN_UP_SUCCESS)") {
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.completionHandler!(success: true, error: nil)
            })
        }
    }
    
    func cancelSignUp() {
        //cancels signup attempt
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}

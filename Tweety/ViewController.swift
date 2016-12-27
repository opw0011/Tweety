//
//  ViewController.swift
//  Tweety
//
//  Created by BennyO on 25/12/2016.
//  Copyright © 2016 BennyO. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    
    @IBOutlet weak var twitterWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SendTweetButtonClicked(_ sender: UIButton) {
        NSLog("Send tweet button is clicked")
        
        // check whether twitter is available in the device
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            // create a tweeter view controller
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            tweetVC?.setInitialText("Testing String")
            
            // show the tweet view controller
            self.present(tweetVC!, animated: true, completion: nil)
        } else {
            NSLog("Your device does not support twitter")
        }
        
    }

    @IBAction func showTweetButtonClicked(_ sender: UIButton) {
        NSLog("Show tweet button is clicked")
        
        // if the url is valid
        /*
        if let targetURL = NSURL(string: "https://twitter.com/superlOrzx") {
            let urlRequest = NSURLRequest(url: targetURL as URL)
            twitterWebView.loadRequest(urlRequest as URLRequest)
        }*/
        
        guard let targetURL = NSURL(string: "https://twitter.com/superlOrzx") else {
            NSLog("Not a valid url")
            return
        }
        let urlRequest = NSURLRequest(url: targetURL as URL)
        twitterWebView.loadRequest(urlRequest as URLRequest)
        
    }
}


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

}


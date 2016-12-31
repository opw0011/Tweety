//
//  TweetDetailViewController.swift
//  Tweety
//
//  Created by BennyO on 31/12/2016.
//  Copyright © 2016 BennyO. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweetString: String?
    var username: String?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = username
        tweetTextView.text = tweetString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

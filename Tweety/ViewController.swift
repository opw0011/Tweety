//
//  ViewController.swift
//  Tweety
//
//  Created by BennyO on 25/12/2016.
//  Copyright © 2016 BennyO. All rights reserved.
//

import UIKit
import Social
import Accounts

class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = [
//        ParsedTweet(tweetText: "Content",
//                    userName: "@oo",
//                    createdAt: "2016-2-23",
//                    userAvatarURL: NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")
//                    ),
//        ParsedTweet(tweetText: "Content 2",
//                    userName: "@o",
//                    createdAt: "2016-7-23",
//                    userAvatarURL: NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_normal.png")
//        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reloadTweets()
        self.refreshControl?.addTarget(self, action: #selector(ViewController.handleRefresh(sender:)), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section \(section)"
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTweetCell") as! ParsedTweetCell
        
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        
        // Load image in background thread
        DispatchQueue.global().async {
            if let url = parsedTweet.userAvatarURL,
                let imageData = NSData(contentsOf: url as URL),
                cell.userNameLabel.text == parsedTweet.userName {
                    // update UI in main thread
                    DispatchQueue.main.async {
                        cell.avatarImageView.image = UIImage(data: imageData as Data)
                    }
            }
        }

        return cell
    }
    
    func reloadTweets() {
        // get twitter account
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        // handler to call when access is granted or denined
        let handler = {(granted: Bool, error: Error?) -> Void in
            guard granted else {
                NSLog("Account access not granted")
                return
            }
            
            // after having permission to access acount store, check if at least one twitter exists
            let twitterAccounts = accountStore.accounts(with: twitterAccountType)
            guard (twitterAccounts?.count)! > 0 else {
                NSLog("No twitter account configured")
                return
            }
            
            // configure twitter API request
            let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json") as! URL
            let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: twitterAPIURL, parameters: ["count" : "50"])
            request?.account = twitterAccounts?.first as! ACAccount!
            
            // make a twitter api request
            request?.perform(handler: { (data: Data?, urlResponse: HTTPURLResponse?, error: Error?) in
                self.handleTwitterData(data: data, urlResponse: urlResponse, error: error)
            })
            
        }
        
        // access to the twitter account
        accountStore.requestAccessToAccounts(with: twitterAccountType, options: nil, completion: handler)
        
    }
    
    // callback function after the twitter API is called
    private func handleTwitterData(data: Data?, urlResponse: HTTPURLResponse?, error: Error?) {
        guard let data = data else {
            NSLog("handleTwitterData() receive no data")
            return
        }
        NSLog("handleTwitterData() \(data.count) bytes")
        
        // try parsing json object
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//            print("json: \(jsonObject)")
            // NSLog("JSON OBJ: \(jsonObject)") // this does not work :(
            
            guard let jsonArray = jsonObject as? [[String: AnyObject]] else {
                NSLog("handleJsonData() did not get json array")
                return
            }
            // remove old data
            parsedTweets.removeAll()
            
            for tweetDict in jsonArray {
                // initialize a new parsedTweet obj
                var parsedTweet = ParsedTweet()
                parsedTweet.tweetText = tweetDict["text"] as? String
                parsedTweet.createdAt = tweetDict["created_at"] as? String
                
                // parse user data
                if let userDict = tweetDict["user"] as? [String: AnyObject] {
                    parsedTweet.userName = userDict["name"] as? String
                    if let avatarURLString = userDict["profile_image_url_https"] as? String {
                        parsedTweet.userAvatarURL = NSURL(string: avatarURLString)
                    }
                }
                
                parsedTweets.append(parsedTweet)
            }
            
            NSLog(Thread.isMainThread ? "main thread" : "not main thread")
            
            // update the UI in the main thread
            DispatchQueue.main.async {
                NSLog( "reload  \(Thread.isMainThread ? "main thread" : "not main thread") ")
                self.tableView.reloadData()
            }
            
        } catch let error as NSError{
            NSLog("JSON Error: \(error)")
        }
    }
    
    @IBAction func handleRefresh (sender: AnyObject?) {
//        parsedTweets.append(
//            ParsedTweet(tweetText: "New tweet",
//                        userName: "@refresh",
//                        createdAt: NSDate().description,
//                        userAvatarURL: NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")
//            )
//        )
        reloadTweets()
        refreshControl?.endRefreshing()
    }
    
    // Action handler when the compose tweet button is clicked
    @IBAction func SendTweetButtonClicked(_ sender: UIBarButtonItem) {
        NSLog("Send tweet button is clicked")
        
        // check whether twitter is available in the device
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            // create a tweeter view controller
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            tweetVC?.setInitialText("This is a awesome iOS app written in Swift 3! #swift3")
            
            // show the tweet view controller
            self.present(tweetVC!, animated: true, completion: nil)
        } else {
            NSLog("Your device does not support twitter")
        }
    }
    
    
    // passing data via a sugue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let row = tableView.indexPathForSelectedRow?.row,
                let tweetDetailVC = segue.destination as? TweetDetailViewController{
                let selectedTweet = parsedTweets[row]
                NSLog("Clicked on \(selectedTweet.tweetText)")
                tweetDetailVC.tweetString = selectedTweet.tweetText
                tweetDetailVC.username = selectedTweet.userName

            }
        
        }
    }
    
    
}


//
//  ViewController.swift
//  Tweety
//
//  Created by BennyO on 25/12/2016.
//  Copyright © 2016 BennyO. All rights reserved.
//

import UIKit
import Social

class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = [
        ParsedTweet(tweetText: "Content",
                    userName: "@oo",
                    createdAt: "2016-2-23",
                    userAvatarURL: NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")
                    ),
        ParsedTweet(tweetText: "Content 2",
                    userName: "@o",
                    createdAt: "2016-7-23",
                    userAvatarURL: NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_normal.png")
        )
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
        if let url = parsedTweet.userAvatarURL, let imageData = NSData(contentsOf: url as URL) {
            cell.avatarImageView.image = UIImage(data: imageData as Data)
        }
        
        return cell
    }
    
    func reloadTweets() {
        tableView.reloadData()
    }
    
    @IBAction func handleRefresh (sender: AnyObject?) {
        parsedTweets.append(
            ParsedTweet(tweetText: "New tweet",
                        userName: "@refresh",
                        createdAt: NSDate().description,
                        userAvatarURL: NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")
            )
        )
        reloadTweets()
        refreshControl?.endRefreshing()
    }
}


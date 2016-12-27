//
//  ParsedTweetCell.swift
//  Tweety
//
//  Created by BennyO on 27/12/2016.
//  Copyright © 2016 BennyO. All rights reserved.
//

import UIKit

class ParsedTweetCell: UITableViewCell {
    
    // connections of elements inside a custom table cell
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//
//  TweetViewCell.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 2/26/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
    @IBOutlet weak var TweetImageView: UIImageView!
    @IBOutlet weak var TweetNameLabel: UILabel!
    @IBOutlet weak var TweetUsernameLabel: UILabel!
    @IBOutlet weak var TweetTimeLabel: UILabel!
    @IBOutlet weak var TweetTextLabel: UILabel!
    
    var tweet: Tweet!{
        didSet{
            TweetNameLabel.text = tweet.name
            TweetImageView.setImageWith(tweet.imageUrl as URL!)
            TweetUsernameLabel.text = tweet.userName
            TweetTextLabel.text = tweet.text as String?
            TweetTimeLabel.text = String(describing: NSDate.timeIntervalSince(tweet.timestamp!))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TweetImageView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

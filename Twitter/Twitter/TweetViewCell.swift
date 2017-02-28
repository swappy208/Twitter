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
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    var timestamp: NSDate!
    
    var tweet: Tweet!{
        didSet{
            TweetNameLabel.text = tweet.name
            TweetImageView.setImageWith(tweet.imageUrl as URL!)
            TweetUsernameLabel.text = "@"+tweet.userName
            TweetTextLabel.text = tweet.text as String?
            if let timestamp = tweet.timestamp {
                TweetTimeLabel.text = TwitterClient.timeelapsed(timestamp: timestamp as Date)
            }
            retweetLabel.text = String(tweet.retweetCount)
            favoritesLabel.text = String(tweet.favoritesCount)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TweetImageView.layer.cornerRadius = 5
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//
//  TweetCell.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 2/18/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            userImageView.setImageWith(tweet.author.userImageURL)
            nameLabel.text = tweet.author.name
            screenNameLabel.text = "@\(tweet.author.screenName)"
            timeStampLabel.text = tweet.timeStampText
            tweetTextLabel.text = tweet.text

            retweetCountLabel.text = "\(tweet.retweetCount)"
            favoriteCountLabel.text = "\(tweet.favoriteCount)"
            
            if tweet.retweeted == true {
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
            } else {
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: UIControlState.normal)
            }
            
            if tweet.favorited == true {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
            } else {
                self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.retweetTweet(success: { (tweet: Tweet) in
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
            // self.unretweetTweet()
        }, tweetId: tweet.id)
    }

    @IBAction func onFavoriteButton(_ sender: Any) {
        TwitterClient.sharedInstance?.favoriteTweet(success: { (tweet: Tweet) in
            self.tweet = tweet
        }, failure: { (error: Error) in
            self.unfavoriteTweet()
        }, tweetId: tweet.id)
    }
    
    func unfavoriteTweet() {
        TwitterClient.sharedInstance?.unfavoriteTweet(success: { (tweet: Tweet) in
            self.tweet = tweet
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        }, tweetId: tweet.id)
    }
}

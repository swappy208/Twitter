
//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 2/27/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.setImageWith(tweet.author.userImageURL)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        nameLabel.text = tweet.author.name
        screenNameLabel.text = "@\(tweet.author.screenName)"
        timeStampLabel.text = tweet.timeStampLongText
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onRetweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.retweetTweet(success: { (tweet: Tweet) in
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            self.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
            // self.unretweetTweet()
        }, tweetId: tweet.id)

    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        TwitterClient.sharedInstance?.favoriteTweet(success: { (tweet: Tweet) in
            self.favoriteCountLabel.text = "\(tweet.favoriteCount)"
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }, failure: { (error: Error) in
            self.unfavoriteTweet()
        }, tweetId: tweet.id)
    }
  
    func unfavoriteTweet() {
        TwitterClient.sharedInstance?.unfavoriteTweet(success: { (tweet: Tweet) in
            self.favoriteCountLabel.text = "\(tweet.favoriteCount)"
            self.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }, failure: { (error: Error) in
            print("error: \(error.localizedDescription)")
        }, tweetId: tweet.id)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Compose stuff
        print("preparing for segue \(segue.identifier)")
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.user = tweet.author
        } else {
            let composeVC = segue.destination as! ComposeViewController
            composeVC.startingText = "@\(tweet.author.screenName)"
        }
    }
}

//
//  Tweet.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 2/23/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userDictionary: NSDictionary
    var name: String
    var userName: String
    var imageUrl: NSURL
    var retweeted: Bool?
    var retweeted_status: Tweet?
    var favorited: Bool?
    var id_str: String?
    var current_user_retweet: Tweet?
    init(dictionary: NSDictionary)
    {
        text = dictionary["text"] as? String as NSString?
        id_str = dictionary["id_str"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        userDictionary = dictionary["user"] as! NSDictionary
        name = userDictionary["name"] as! String
        userName = NSString(string: userDictionary["screen_name"] as! String!) as String
        imageUrl = NSURL(string: userDictionary["profile_image_url_https"] as! String)!
        favoritesCount = (userDictionary["favourites_count"] as? Int) ?? 0
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
        let current_user_retweet_dict = (dictionary["current_user_retweet"] as? NSDictionary)
        if current_user_retweet_dict != nil {
            current_user_retweet = Tweet(dictionary: current_user_retweet_dict!)
        } else {
            current_user_retweet = nil
        }
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        let retweeted_status_dict = (dictionary["retweeted_status"] as? NSDictionary) ?? nil
        if retweeted_status_dict != nil {
            retweeted_status = Tweet(dictionary: retweeted_status_dict!)
        } else {
            retweeted_status = nil
        }
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as? Bool
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]
    {
        var tweets = [Tweet]()
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}

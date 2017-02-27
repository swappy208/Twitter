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
    init(dictionary: NSDictionary)
    {
        text = dictionary["text"] as? String as NSString?
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        userDictionary = dictionary["user"] as! NSDictionary
        name = userDictionary["name"] as! String
        userName = NSString(string: userDictionary["screen_name"] as! String!) as String
        imageUrl = NSURL(string: userDictionary["profile_image_url_https"] as! String)!
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
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

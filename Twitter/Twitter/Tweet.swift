
//
//  Tweet.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 3/4/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String
    var retweeted: Bool
    var retweetCount: Int = 0
    var favorited: Bool
    var favoriteCount: Int = 0
    var author: User
    var id: Int = 0
    
    var timeStamp: Date
    var timeStampText: String {
        get {
            let calendar = Calendar.current
            let TSYear = calendar.component(.year, from: timeStamp)
            let TSMonth = calendar.component(.month, from: timeStamp)
            let TSDay = calendar.component(.day, from: timeStamp)
            let TSHour = calendar.component(.hour, from: timeStamp)
            let TSMinute = calendar.component(.minute, from: timeStamp)
            
            let date = Date()
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            if TSYear != year {
                return "\(TSMonth)/\(TSDay)/\(TSYear)"
            } else {
                if TSMonth != month {
                    return "\(TSMonth)/\(TSDay)/\(TSYear)"
                } else {
                    if TSDay != day {
                        if day - TSDay < 7 {
                            return "\(day - TSDay)d"
                        } else {
                            return "\(TSMonth)/\(TSDay)/\(TSYear)"
                        }
                    } else {
                        if TSHour != hour {
                            return "\(hour - TSHour)h"
                        } else {
                            if minute == TSMinute {
                                return "Just now"
                            }
                            return "\(minute - TSMinute)m"
                        }
                    }
                }
            }
        }
    }
    var timeStampLongText: String {
        get {
            let calendar = Calendar.current
            let TSYear = calendar.component(.year, from: timeStamp)
            let TSMonth = calendar.component(.month, from: timeStamp)
            let TSDay = calendar.component(.day, from: timeStamp)
            let TSHour = calendar.component(.hour, from: timeStamp)
            let TSMinute = calendar.component(.minute, from: timeStamp)
            
            var hour = TSHour
            var AMPM: String
            if hour < 12 {
                if hour == 0 {
                    hour = 12
                }
                AMPM = "AM"
            } else {
                hour -= 12
                AMPM = "PM"
            }
            return "\(TSMonth)/\(TSDay)/\(TSYear), \(TSHour):\(TSMinute) \(AMPM)"
        }
    }
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as! String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0

        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString)!
        } else {
            timeStamp = Date()
        }
        author = User(dictionary: dictionary["user"] as! NSDictionary)
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        id = dictionary["id"] as! Int
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}

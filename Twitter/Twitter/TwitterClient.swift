//
//  TwitterClient.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 2/23/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "PdikoeXtf9h6zqO0R16gQEa38", consumerSecret: "3DCjfbH3aDCDg57cDAWyIJJ4lUffMyaPOwbiu3vyRUXlfY1o9D")

    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: (NSError) -> ())
    {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task,Error ) in
        })
    }
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (NSError) -> ())
    {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            print("account: \(response)")
            
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile: \(user.profileUrl)")
            print("description: \(user.tagline)")
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error as NSError)
        })
    }
    var loginSuccess: (() -> ())?
    var loginfailure: ((NSError) -> ())?
    func login(success: @escaping () -> (), failure: @escaping (NSError)-> ())
    {
        loginfailure = failure
        loginSuccess = success
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print ("I got a token that is \((requestToken?.token)!)")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken!.token)!)") as URL!
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }, failure: { (Error) in
            
            print ("error:\(Error?.localizedDescription)")
            self.loginfailure?(Error as! NSError)
        })
    }
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (accessToken: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error) in
               self.loginfailure?(error)
            })
        }, failure: { (Error) in
            print ("error:\(Error?.localizedDescription)")
            self.loginfailure?(Error as! NSError)
        })
    }
    func logout(){
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    static func timeelapsed(timestamp: Date) -> String {
        let interval = timestamp.timeIntervalSinceNow
        
        if interval < 60 * 60 * 24 {
            let seconds = -Int(interval.truncatingRemainder(dividingBy: 60))
            let minutes = -Int((interval / 60).truncatingRemainder(dividingBy: 60))
            let hours = -Int((interval / 3600))
            
            let result = (hours == 0 ? "" : "\(hours)h ") + (minutes == 0 ? "" : "\(minutes)m ") + (seconds == 0 ? "" : "\(seconds)s")
            return result
        } else {
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "EEE/MMM/d"
                return f
            }()
            return formatter.string(from: timestamp as Date)
        }
    }
    func retweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/" + (tweet.id_str)! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func favorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json", parameters: ["id": (tweet.id_str)!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
    
    func unretweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        if !tweet.retweeted! {
        } else {
            var original_tweet_id: String?
            
            if tweet.retweeted_status == nil {
                original_tweet_id = tweet.id_str
            } else {
                original_tweet_id = tweet.retweeted_status?.id_str
            }
            get("1.1/statuses/show.json", parameters: ["id": original_tweet_id!, "include_my_retweet": true], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionary = response as? NSDictionary
                let full_tweet = Tweet(dictionary: dictionary!)
                let retweet_id = full_tweet.current_user_retweet?.id_str
                // step 3
                self.post("1.1/statuses/unretweet/" + retweet_id! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                    let dictionary = response as? NSDictionary
                    let tweet = Tweet(dictionary: dictionary!)
                    success(tweet)
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    failure(error)
                })
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func unfavorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json", parameters: ["id": tweet.id_str!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }

}

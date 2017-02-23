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
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "Val98L5TvdFFO8OC8yTwLVghl", consumerSecret: "DwztDdC2mmDxaO6M5nNjx3mwam8UXfv51HpOTJJkSPguqRUGNW")
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: (NSError) -> ())
    {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task,Error ) in
        })
    }
    func currentAccount()
    {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) -> Void in
            print("account: \(response)")
            
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile: \(user.profileUrl)")
            print("description: \(user.tagline)")
        }, failure: { (task, Error) in
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
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)") as URL!
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }, failure: { (Error) in
            
            print ("error:\(Error?.localizedDescription)")
            self.loginfailure?(Error as! NSError)
        })
    }
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken!, success: { (accessToken: BDBOAuth1Credential?) in
            self.loginSuccess?()
            /*self.homeTimeLine(success: { (tweets) in
                for tweet in tweets{
                    print(tweet.text)
                }
            }, failure: <#T##NSError#>)
            self.currentAccount()
            */
        }, failure: { (Error) in
            print ("error:\(Error?.localizedDescription)")
            self.loginfailure?(Error as! NSError)
        })
    }
}

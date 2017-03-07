
//
//  TwitterClient.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 3/4/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "PdikoeXtf9h6zqO0R16gQEa38", consumerSecret: "3DCjfbH3aDCDg57cDAWyIJJ4lUffMyaPOwbiu3vyRUXlfY1o9D")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: { (Bool) in
            })
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil, userInfo: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (
            accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user:User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure!(error)
            })
            
        }, failure: { (error:Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!);
        })
    }
    
    func currentAccount(success:@escaping (User) -> (), failure:@escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user);
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task, error) in
            failure(error)
        })
    }
    
    func getUser(success: @escaping (User) -> (), failure: @escaping (Error) -> (), userID: Int) {
        print("will call")
        get("1.1/users/show.json", parameters: ["user_id": userID], progress: nil, success: { (task, response) in
            print("success?!")
            let dictionary = response as! NSDictionary
            let user = User(dictionary: dictionary)
            print("got user profile!:\n\(user.dictionary)")
            success(user)
            
        }, failure: { (task, error) in
            print("failure?!")
            failure(error)
        })
        print("did call")
    }
    
    func favoriteTweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetId: Int) {
        post("1.1/favorites/create.json", parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unfavoriteTweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetId: Int) {
        post("1.1/favorites/destroy.json", parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweetTweet(success: @escaping (Tweet) -> (), failure: @escaping (Error) -> (), tweetId: Int) {
        post("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            tweet.retweeted = true
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func postTweet(success: @escaping () -> (), failure: @escaping (Error) -> (), status: String) {
        post("1.1/statuses/update.json", parameters: ["status": status], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("posted tweet!! \(status)")
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
}

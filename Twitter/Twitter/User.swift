//
//  User.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 3/4/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: Int = 0
    var name: String
    var screenName: String
    var userImageURL: URL
    var bannerImageURL: URL?
    var tagLine: String
    var followingCount: Int = 0
    var followingString: String {
        get {
            if followingCount >= 1000000 {
                return "\(Double(followingCount/100000).rounded()/10)m"
            } else if followingCount >= 1000 {
                return "\(Double(followingCount/100).rounded()/10)k"
            } else {
                return "\(followingCount)"
            }
        }
    }
    var followersCount: Int = 0
    var followersString: String {
        get {
            if followersCount >= 1000000 {
                return "\(Double(followersCount/100000).rounded()/10)m"
            } else if followersCount >= 1000 {
                return "\(Double(followersCount/100).rounded()/10)k"
            } else {
                return "\(followersCount)"
            }
        }
    }
    var tweetsCount: Int = 0
    var tweetsString: String {
        get {
            if tweetsCount >= 1000000 {
                return "\(Double(tweetsCount/100000).rounded()/10)m"
            } else if tweetsCount >= 1000 {
                return "\(Double(tweetsCount/100).rounded()/10)k"
            } else {
                return "\(tweetsCount)"
            }
        }
    }

    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary["id"] as! Int
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as! String
        userImageURL = URL(string: dictionary["profile_image_url_https"] as! String)!
        bannerImageURL = URL(string: dictionary["profile_banner_url"] as? String ?? "")
        tagLine = dictionary["description"] as! String
        followingCount = dictionary["friends_count"] as! Int
        followersCount = dictionary["followers_count"] as! Int
        tweetsCount = dictionary["statuses_count"] as! Int
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let data = defaults.object(forKey: "currentUserData") as? Data
                if let data = data {
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}

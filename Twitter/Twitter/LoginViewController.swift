//
//  LoginViewController.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 2/21/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "Val98L5TvdFFO8OC8yTwLVghl", consumerSecret: "DwztDdC2mmDxaO6M5nNjx3mwam8UXfv51HpOTJJkSPguqRUGNW")
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print ("I got a token that is \((requestToken?.token)!)")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)") as URL!
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }, failure: { (Error) in
            
            print ("error:\(Error?.localizedDescription)")
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

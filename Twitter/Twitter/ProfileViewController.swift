
//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Swapnil Tamrakar on 3/4/17.
//  Copyright © 2017 Swapnil Tamrakar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userWrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = user.name
        
        if let bannerImageURL = user.bannerImageURL {
            bannerImageView.setImageWith(bannerImageURL)
        }
        
        userWrapperView.layer.cornerRadius = 5
        userWrapperView.clipsToBounds = true
        
        userImageView.setImageWith(user.userImageURL)
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName
        descriptionLabel.text = user.tagLine
        tweetsCountLabel.text = user.tweetsString
        followingCountLabel.text = user.followingString
        followersCountLabel.text = user.followersString
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Compose stuff
        let composeVC = segue.destination as! ComposeViewController
        composeVC.startingText = "@\(user.screenName)"
    }
}

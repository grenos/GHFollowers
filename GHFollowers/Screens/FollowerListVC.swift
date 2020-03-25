//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 24/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errosMessage in
            
            // check if we actually get folowers or its nil
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: errosMessage!.rawValue, buttonTitle: "Ok")
                return
            }
            
            print(followers.count)
            print(followers)
            
        }
    }
    
    // component will focus
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // show navbar on this screen
        // called in this lifecycle because we need to show it everytime we enter this screen
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
}

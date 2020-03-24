//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 23/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    // init the elements for the screen
    let logoImageView = UIImageView()
    let userNameTextFiled = GFTextField()
    let CTAButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    

    // component did mount
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    // component will focus
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // hide navbar on this screen
        // called in this lifecycle because we need to hide it everytime we enter this screen
        navigationController?.isNavigationBarHidden = true
    }
    
}

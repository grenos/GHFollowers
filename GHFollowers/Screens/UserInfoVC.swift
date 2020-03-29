//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 29/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    // username gets passed here from FollowerListVC from function -- extension FollowerListVC: UICollectionViewDelegate --
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        // create done button for navigation
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        // add button to navigation bar
        navigationItem.rightBarButtonItem = doneButton
        print(username!)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    

}

//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 04/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

// THIS CLASS IS A SUBLCLASS OF GFItemInfoVC, IT INHERITS ALL OF ITS PROPERTIES

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
    }
    
    private func configureItems() {
        // 1) get itemInfoView1 which is declarered in the superClass GFItemInfoVC
        // 2) itemInfoView1 is GFItemInfoView() created to hold the symbols and github info
        // 3) set is a func created in GFItemInfoView to controlls what info to show based on what we pass with itemInfoType
        // 4) the user object is passed from the superClass, which we pass from the UserInfoVC screen
        itemInfoView1.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    
    // call the func from the parent class
    override func actionButtonTapped() {
        // call the didTapGithubProfile func declared in the delegate UserInfoVC
        delegate.didTapGithubProfile(for: user)
    }
}

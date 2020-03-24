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
        
        configureLogoImageView()
        configureTextField()
        configureCTAButton()
    }
    
    // component will focus
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // hide navbar on this screen
        // called in this lifecycle because we need to hide it everytime we enter this screen
        navigationController?.isNavigationBarHidden = true
    }
    
    
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")!
        
        NSLayoutConstraint.activate([
            // place it on top after the safeArea and give it a margin of 80
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            // center the image in the view horizontally
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // set image height
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            // set width
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    
    
    func configureTextField() {
        view.addSubview(userNameTextFiled)
        
        NSLayoutConstraint.activate([
            // place textField at the bottom of the imageView with a top margin of 48
            userNameTextFiled.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            // pin one side to the begining of the entire view and give it a margin of 50
            userNameTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            // same thing as above but for the end of the input and the rigth side of the screen
            userNameTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            // set height
            userNameTextFiled.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    func configureCTAButton() {
        view.addSubview(CTAButton)
        
        NSLayoutConstraint.activate([
            // set button on bottom after the safeArea and give a margin of 50
            CTAButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            // pin to left of screen and give a margin of 50
            CTAButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            // same as above but from the right side
            CTAButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            // give it a height of 50
            CTAButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
}

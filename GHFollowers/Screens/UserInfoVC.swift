//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 29/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    var itemViews: [UIView] = []
    
    // username gets passed here from FollowerListVC from function -- extension FollowerListVC: UICollectionViewDelegate --
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureVC()
        layoutUI()
        getUserInfo()
    }
    
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        // create done button for navigation
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        // add button to navigation bar
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    
    // MARK: Network call
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoheaderVC(user: user), to: self.headerView)
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    
    // MARK: UI layout
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo]
        let padding: CGFloat = 20
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            //add left-right padding
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        itemViewOne.backgroundColor = .systemPink
        itemViewTwo.backgroundColor = .systemBlue

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    

}

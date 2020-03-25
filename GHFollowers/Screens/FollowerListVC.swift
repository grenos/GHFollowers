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
    var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers()
    }
    
    // component will focus
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // show navbar on this screen
        // called in this lifecycle because we need to show it everytime we enter this screen
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    // MARK: View Controller Config
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView() {
        // init collection view
        // view.bounds to fill up the whole screen of the phone
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        // add collection view to Screen
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemPink
        
        // registrer the cell in the collection view
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    
    // MARK: API call
    func getFollowers() {
        // api call for followers
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            
            switch result {
            case .success(let followers):
                print(followers.count)
                print(followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
    
}

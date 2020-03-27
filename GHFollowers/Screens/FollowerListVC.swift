//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 24/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {
    
    // enums are hashable by default
    enum Section {
        case main
    }
    
    var username: String!
    var collectionView: UICollectionView!
    
    var followers: [Follower] = []
    
    // takes 2 generic paraeters
    // both of them need to conform to hashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        // add collection view to Screen
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        
        // registrer the cell in the collection view
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    
    // called in init
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    // called every time a new response arrives from the server
    func updateData() {
        // declare snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        // tell what section it needs to wathc
        snapshot.appendSections([Section.main])
        // the items array that needs to check for changes
        snapshot.appendItems(followers)
        // applay the snapshots to the dataSource
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    
    // MARK: API call
    func getFollowers() {
        // api call for followers
        // CHECK PLAYGROUND FOR DETAILS
        // [week self] --> capture list
        // when a self becomes weak the value of that becomes optional
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
            // instead of adding self?. to all values below use guard for the self
            guard let self = self else { return }
            
            switch result {
            case .success(let followers):
                // save the response in the followers array we declared
                self.followers = followers
                // call update data to keep the list updated with latest response
                self.updateData()
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
    
    
    
    
}

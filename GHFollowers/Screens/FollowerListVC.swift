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
    
    // username is the inout text passed from the SearchVC
    var username: String!
    var collectionView: UICollectionView!
    
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    
    // takes 2 generic paraeters
    // both of them need to conform to hashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: page)
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
        
        // set the delegate to pass methods to View Controller
        collectionView.delegate = self
        
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
    func getFollowers(username: String, page: Int) {
        // api call for followers
        // CHECK PLAYGROUND FOR DETAILS
        // [week self] --> capture list
        // when a self becomes weak the value of that becomes optional
        
        // show activity indicator before the network call --- EXTENSIONS FILE ---
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            // instead of adding self?. to all values below use guard for the self
            guard let self = self else { return }
            
            // call to dismiss the loading indicator --- EXTENSIONS FILE ---
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                // if no more follower turn switch off
                // we use 100 because it is our page limit
                if followers.count < 100 { self.hasMoreFollowers = false }
                // save the response in the followers array we declared and use append to save the next 100 results (concat, push)
                self.followers.append(contentsOf: followers)
                // call update data to keep the list updated with latest response
            
                // control if array is returned empty and show empty state view
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them! 😜"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                
                // call to update snapshot
                self.updateData()
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
    
}

// MARK: Pagination
// Conform to the collection View delegate to recieve the methods of the Collection View
// (ue delegate to --> wait for an action to happen and act)
extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // get how much we have scrolled
        let offsetY = scrollView.contentOffset.y
        // get how much is the size of the entire controller (with scroll)
        let contentHeight = scrollView.contentSize.height
        // get height of scrollView on screen
        let scrollViewHeight = scrollView.frame.size.height
        
        // if our offset is more than the entire scroll distance plus the screenheight
        // it means we reached the end so we need to call the next page
        if offsetY > contentHeight - scrollViewHeight {
            
            // if no more followers return
            guard hasMoreFollowers else { return }
            
            page += 1
            getFollowers(username: username, page: page)
        }
        
        
        
    }
}

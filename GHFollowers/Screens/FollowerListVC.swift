//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 24/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit



protocol FollowerListVCDelegate: class {
    func didRequestFollowers(for username: String)
}



class FollowerListVC: GFDataLoadingVC {
    
    // enums are hashable by default
    enum Section {
        case main
    }
    
    // username is the inout text passed from the SearchVC
    var username: String!
    var collectionView: UICollectionView!
    
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    
    // takes 2 generic paraeters
    // both of them need to conform to hashable
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    
    // username is the inout text passed from the SearchVC
    init (username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureSearchController()
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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavorites))
        // add button to navigation bar
        navigationItem.rightBarButtonItem = addButton
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
    func updateData(on followers: [Follower]) {
        // declare snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        // tell what section it needs to wathc
        snapshot.appendSections([Section.main])
        // the items array that needs to check for changes
        snapshot.appendItems(followers)
        // applay the snapshots to the dataSource
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        
        // set the delegate for searchResultsUpdater
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search followers"
        // set overlay to false so we can tap on a user
        searchController.obscuresBackgroundDuringPresentation = false
        
        // set the searchController we created as a nav item (so we cam see it in the bav)
        navigationItem.searchController = searchController
        
    }
    
    
    
    // MARK: Add to Favorites Calls
    @objc func addToFavorites() {
        
        // make network call with username to retreive the user avatar (shit code design)
        // showloading
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
                
            // success return the user
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistanceManager.updateWith(favorite: favorite, actionType: .add) { [weak self ] error in
                    guard let self = self else { return }
                    // check to see if we have recieved and error
                    guard let error = error else {
                        // if error was nil ( no error)
                        self.presentGFAlertOnMainThread(title: "Success!", message: "User was successfully added to the favorite list! 🥳", buttonTitle: "Horray!")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Somethig went wrong!", message: error.rawValue, buttonTitle: "Ok")
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
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
                
                // call to update snapshot with the followers array
                self.updateData(on: self.followers)
                

                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
    
}



// MARK: EXTENSIONS





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
    
    
    // get the exact tapped item from the collection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get the right array to use first
        let activeArray = isSearching ? filteredFollowers : followers
        //get the index of the tapped item
        let follower = activeArray[indexPath.item]
        
        // Navigate to modal
        let userInfoVC = UserInfoVC()
        // pass the username to the modal to use at the user api call
        userInfoVC.username = follower.login
        // set this vc as delegate of the UserInfoVC
        // now this VC is listening to the userinfoìVC for new data
        userInfoVC.delegate = self
        // we put the modal inside a NavController so we could have the navigation buttons in the modal
        let navController = UINavigationController(rootViewController: userInfoVC)
        present(navController, animated: true)
    }
    
}


// MARK: Filter arrays
extension FollowerListVC: UISearchResultsUpdating {
    
    // this informs the VC every time the search results are changed
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        
        //set the switch on
        isSearching = true
        
        // get each item of the followers array
        // check if contains the text from the searchBar
        // append the return to the filteredFollowers array
        filteredFollowers = followers.filter {
            $0.login.lowercased().contains(filter.lowercased())
        }
        
        // Update collection view with new results passing the new array
        updateData(on: filteredFollowers)
    }
}


// MARK: Delegate
extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        // get followers for new user
        self.username = username
        // set navbar title
        title = username
        // reset pagination couter
        page = 1
        // reset items from arrays
        followers.removeAll()
        filteredFollowers.removeAll()
        // set collectionView to starting point
        collectionView.setContentOffset(.zero, animated: true)
        // make the call to get followers with new username
        getFollowers(username: username, page: page)
    }
}

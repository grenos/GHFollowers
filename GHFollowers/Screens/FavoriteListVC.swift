//
//  FavoriteListVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 23/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class FavoriteListVC: UIViewController {
    
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    
    // get new followers on screen focus
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getFavorites()
    }
    
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        // fillup the entire window with the tableview
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    
    func getFavorites() {
        PersistanceManager.retrieveFavorites { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let favorites):
                
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen!", in: self.view)
                } else {
                    // self.favorites is: var favorites: [Follower] = []
                    // favorites is: let favorites
                    self.favorites = favorites
                    // restamp table with new data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        // covers edge case where the empty state view was the one printed first
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
          
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Wops! Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
}




extension FavoriteListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    
    // get the selected row of the tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationVC = FollowerListVC(username: favorite.login)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    // SWIPE TO DELETE ROW
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // make sure we delete
        guard editingStyle == .delete else { return }
        
        // get selected user to delete
        let favorite = favorites[indexPath.row]
        // delete user from array that we use to populate the tableview
        favorites.remove(at: indexPath.row)
        // delete user from the tableView
        tableView.deleteRows(at: [indexPath], with: .left)
        
        
        // delete user from persistnace
        PersistanceManager.updateWith(favorite: favorite, actionType: PersistanceActionType.remove) { [weak self] (error) in
            guard let self = self else { return }
            
            // if we dont have error dont do nothing and return
            guard let error = error else { return }
            
            // if we have an error
            self.presentGFAlertOnMainThread(title: "Oooops. Unable to remove user 😩", message: error.rawValue, buttonTitle: "Ok")
            
            
        }
    }
}

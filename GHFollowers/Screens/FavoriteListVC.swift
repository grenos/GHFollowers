//
//  FavoriteListVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 23/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class FavoriteListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        PersistanceManager.retrieveFavorites { (result) in
            print(result)
        }
    }    
    
}

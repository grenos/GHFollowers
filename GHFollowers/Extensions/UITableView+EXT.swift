//
//  UITableView+EXT.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 13/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit


extension UITableView {
    func removeUnusedCells() {
        tableFooterView = UIView(frame: .zero)
    }
}

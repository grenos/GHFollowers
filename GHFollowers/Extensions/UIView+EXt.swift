//
//  UIView+EXt.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 13/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

extension UIView {
    
    
    // VARIADIC PARAMETERS
    // add 3 dots after the parameter and we can add as many params as we want that are all repreented in an array
    // exactly as a rest operator in JS
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    
}

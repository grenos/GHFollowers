//
//  GFButton.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 23/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class GFButton: UIButton {
    
    override init(frame: CGRect) {
        // init apple UIButton class
        super.init(frame: frame)
        
        // custom code
        configure()
        
    }
    
    // this is needed to init things only when we use storyboard -- now is empty
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // custom initializer to pass title and color when we init a new button
    init(backgroundColor: UIColor, title: String ){
        // don't need a frame dimension for this one
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        // set title and state of button (normal, pressed, disabled ecc)
        self.setTitle(title, for: .normal)
        configure()
    }
    
    
    // is private -- can only be called from within this class
    private func configure() {
        // setup generic styles
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        // dynamic font (app responds to global text size changes)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}

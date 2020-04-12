//
//  GFButton.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 23/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

// MARK: This conponent can be initialized either with the default init or with the custom initializer

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
    convenience init(backgroundColor: UIColor, title: String ){
        // don't need a frame dimension for this one
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        // set title and state of button (normal, pressed, disabled ecc)
        self.setTitle(title, for: .normal)
    }
    
    
    // is private -- can only be called from within this class
    private func configure() {
        // setup generic styles
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        // dynamic font (app responds to global text size changes)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    // this is to configure our button after the first init of the button
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
    
}

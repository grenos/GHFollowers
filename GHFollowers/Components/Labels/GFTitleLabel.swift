//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 24/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class GFTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // with a concenience inti we have to call the designated init of the class
    // and if we need to init the class with our custom init, here for example configure() will be called anyway
    // this way can have more custom initializers and dont have to call the functions to each one of them
    
    // With a convenience init we can also give default values to paramteres so fpr example:
    // if we have a super customized view that takes 5-6 params but we dont need to use all of them we can just pass the ones we need
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    
    private func configure () {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        // put ... if the line is too long
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    

}

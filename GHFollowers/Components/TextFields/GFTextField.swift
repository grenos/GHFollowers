//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 23/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom code
        configure()
        
    }
    
    // storyboard init -- not needed --
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // generic styles
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        // .label --> system color that changes automatically with dark/light mode
        textColor = .label
        // cursor color
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        //keyboardType = .default
        returnKeyType = .search
        
        // add x button to clear text input
        clearButtonMode = .whileEditing
        
        placeholder = "Enter a username"
    }
}

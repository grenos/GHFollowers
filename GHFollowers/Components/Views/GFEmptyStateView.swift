//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 28/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // with the customs inits we can pass params when we call this view and initialize them
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func configureUI() {
        configureMessageLabel()
        configureLogoImageView()
    }
    
    
    private func configureMessageLabel() {
        addSubview(messageLabel)
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        //center item on screen verrtically and then push up a litle bit
        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -80 : -150
        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant)
        messageLabelCenterYConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            // hard code height since we know the text message already
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
        ])
    }
    
    
    
    private func configureLogoImageView() {
        addSubview(logoImageView)
        logoImageView.image = Images.emptyStateLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 80 : 40
        let logoImageViewBottomConstraint = logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstant)
        logoImageViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            // take the image and make it 1.3 times larger then it curretn width (scale: 1.3)
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            // make height same as width (height will be 1.3 times larger)
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            // we use 200 to push the element TOWARDS the edge and not pull it like we did any other time
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170)
            // same as above (push insted of pull) so not using a negative number in constant
        ])
    }
    
    
}

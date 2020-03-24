//
//  UIViewController+EXT.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 24/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

// This extension is to be applied to all UIViewControllers used in this app
extension UIViewController {
    
    
    /*  we need to set this alert to be presented in the main thread because
        sometimes we will need to call it from a background thread and it's ilegal to mount
        UI elements called from the background thread
    */
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        // quick way to throw things into the main thread
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
        
    }
    
}

//
//  UIViewController+EXT.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 24/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit
import SafariServices

// We cant save variables inside an extension so we decalre a 'global' variable inside this file
// This global var with the keyword 'fileprivate' is available only in this file and not the entire programm
fileprivate var containerView: UIView!


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
    
    
    func showLoadingView() {
        // init container view and set it to fill the entire screen
        containerView = UIView(frame: view.bounds)
        // add the container view into the VC view (which ever is going to call this func)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        // animate alpha
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        
        // add activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // center indicator on containerView
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
        
    }
    
    func dismissLoadingView() {
        // We will always going to dismiss Loading View from a background thread
        // because we call this function from the Network manager closure (promise)
        // to avoid that we need to throw it in the main thread
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    
    // calling this function from a VC we wiil pass the message and a the view so we know where to constrain it
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        // fill up the entire screen
        emptyStateView.frame = view.bounds
        // add it to the VC subView
        view.addSubview(emptyStateView)
    }
    
    
    func preserntSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
}

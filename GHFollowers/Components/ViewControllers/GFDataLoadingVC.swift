//
//  GFDataLoadingVC.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 12/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class GFDataLoadingVC: UIViewController {
    
    var containerView: UIView!

    func showLoadingView() {
        // init container view and set it to fill the entire screen
        containerView = UIView(frame: view.bounds)
        // add the container view into the VC view (which ever is going to call this func)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        // animate alpha
        UIView.animate(withDuration: 0.25) {
            self.containerView.alpha = 0.8
        }
        
        
        // add activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // center indicator on containerView
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
        
    }
    
    func dismissLoadingView() {
        // We will always going to dismiss Loading View from a background thread
        // because we call this function from the Network manager closure (promise)
        // to avoid that we need to throw it in the main thread
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
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


}

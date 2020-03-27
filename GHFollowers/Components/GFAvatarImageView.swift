//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 25/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure () {
        layer.cornerRadius = 10
        // clip image to bounds of view
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        
        // convert urlString to NSString
        let cacheKey = NSString(string: urlString)
        
        // cacheKey already cached then return and dont download
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        // else go down here and download the image
        
        // if param is not valid url return
        guard let url = URL(string: urlString) else { return }
        
        // make api call
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self else { return }
            
            // if calls returns error return
            if error != nil { return }
            //if response exists and is not nil and if status code is 200(OK)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            // check if we actually have data returned
            guard let data = data else { return }
            
            // pass the server data to the image
            guard let image = UIImage(data: data) else { return }
            
            // save downloaded image to chache
            self.cache.setObject(image, forKey: cacheKey)
            
            // get on the main thread to update UI
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        
        task.resume()
    }
}

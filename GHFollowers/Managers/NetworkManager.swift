//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 25/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com"
    
    //init caching
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    // MARK: @escaping closure explenation
    /*
     Closures can be escaping or non escaping. If a closuse is escaping can 'outlive' the function that is declared in
     It is used for asychronus operations (basically like a promise in JavaScript)
     When we use an escaping closure we need to deal also with memory management (that why we use [weak self] on the return of the promise
     */
    
    
    
    
    // MARK: Followers Call
    func getFollowers(for username: String, page: Int, completed: @escaping(Result<[Follower], GFError>) -> Void) {
        // set endpoint
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        // make sure endpoint is a valid string
        guard let url = URL(string: endpoint) else {
            // if not we need to pass an error message to the callback (completed)
            // so our ViewController that calls that function can print the custom alert
            // because we should print Views only from main thread
            
            // call the callback and pass the error
            completed(.failure(.invalidUsername))
            return
        }
        
        
        // URL Session data task (call api)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // if error exists and its not nil
            // this error will return if the network call wasn't even made
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            // if response exists and is not nil and if status code is 200(OK)
            // cast it as a HTTPURLResponse adn save in the variable
            // ELSE call completed with the error string
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // check if the data response is good and save in the variable data
            // else call completed
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            // Decode JSON file and place it in model
            do {
                let decoder = JSONDecoder()
                // convert keys from snake_case to camelCase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // array we want to create          its type        from the data constant from above
                let followers = try decoder.decode([Follower].self, from: data)
                // if all ok call the completed callback, passing the array and nil for error
                completed(.success(followers))
                
            } catch {
                // if the decoder above throws
                completed(.failure(.invalidData))
            }
            
            
        }
        
        // start network call
        task.resume()
    }
    
    
    
    
    // MARK: User Call
    func getUserInfo(for username: String, completed: @escaping(Result<User, GFError>) -> Void) {
        // set endpoint
        let endpoint = baseUrl + "/users/\(username)"
        
        // make sure endpoint is a valid string
        guard let url = URL(string: endpoint) else {
            // if not we need to pass an error message to the callback (completed)
            // so our ViewController that calls that function can print the custom alert
            // because we should print Views only from main thread
            
            // call the callback and pass the error
            completed(.failure(.invalidUsername))
            return
        }
        
        
        // URL Session data task (call api)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // if error exists and its not nil
            // this error will return if the network call wasn't even made
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            // if response exists and is not nil and if status code is 200(OK)
            // cast it as a HTTPURLResponse adn save in the variable
            // ELSE call completed with the error string
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            // check if the data response is good and save in the variable data
            // else call completed
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            // Decode JSON file and place it in model
            do {
                let decoder = JSONDecoder()
                // convert keys from snake_case to camelCase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                // convert date to a standard Date format
                decoder.dateDecodingStrategy = .iso8601
                // array we want to create          its type        from the data constant from above
                let user = try decoder.decode(User.self, from: data)
                // if all ok call the completed callback, passing the array and nil for error
                completed(.success(user))
                
            } catch {
                // if the decoder above throws
                completed(.failure(.invalidData))
            }
            
            
        }
        
        // start network call
        task.resume()
    }
    
    
    
    // MARK: Avatar Download
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        // CHECK IF IMAGE IS CACHED SO WE DONT DOWNLOD AGAIN
        
        // convert urlString to NSString
        let cacheKey = NSString(string: urlString)
        
        // cacheKey already cached then return it and dont download
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        // else go down here and download the image
        
        // if param is not valid url return
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        // make api call
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // combine all guard statements into one
            // if all the following are true go ahead and do things
            // else completed(nil)
            guard let self = self,
                // if calls returns error return
                error == nil,
                //if response exists and is not nil and if status code is 200(OK)
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                // check if we actually have data returned
                let data = data,
                // pass the server data to the image
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            
            // save downloaded image to chache
            self.cache.setObject(image, forKey: cacheKey)
            
            // if all ok call completed with image
            completed(image)
            
        }
        
        task.resume()
    }
    
    
    
    
}

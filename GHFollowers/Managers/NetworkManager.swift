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
    
}

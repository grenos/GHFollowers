//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 25/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    let baseUrl = "https://api.github.com"
    
    private init() {}
    
    
    func getFollowers(for username: String, page: Int, completed: @escaping([Follower]?, ErrorMessage?) -> Void) {
        // set endpoint
        let endpoint = baseUrl + "/users/\(username)/followers?per_page=100&page=\(page)"
        
        // make sure endpoint is a valid string
        guard let url = URL(string: endpoint) else {
            // if not we need to pass an error message to the callback (completed)
            // so our ViewController that calls that function can print the custom alert
            // because we should print Views only from main thread
            
            // call the callback and pass nil for the followers array
            // then for the error pass the string
            completed(nil, .invalidUsername)
            return
        }
        
        
        // URL Session data task (call api)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // if error exists and its not nil
            // this error will return if the network call wasn't even made
            if let _ = error {
                completed(nil, .unableToComplete)
                return
            }
            
            
            // if response exists and is not nil and if status code is 200(OK)
            // cast it as a HTTPURLResponse adn save in the variable
            // ELSE call completed with the error string
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                return
            }
            
            
            // check if the data response is good and save in the variable data
            // else call completed
            guard let data = data else {
                completed(nil, .invalidData)
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
                completed(followers, nil)
                
            } catch {
                // if the decoder above throws
                completed(nil, .invalidData)
            }
            
            
        }
        
        // start network call
        task.resume()
        
        
        
    }
    
}

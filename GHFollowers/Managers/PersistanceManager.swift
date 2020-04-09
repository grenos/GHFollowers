//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 09/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}



enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    
    // MARK: Get/Set Favorites Function
    // We call this function with params:
    // the follower we need to add to favorites
    // the action type from the enum above
    // it can optionally return an error if we can't save
    static func updateWith(favorite: Follower, actionType: PersistanceActionType, completed: @escaping (GFError?) -> Void) {
        
        // first we need to get the favorites array from User Defaults
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                
                // create a new array from the favorites array (because now it is imutable)
                var retrievedFavorites = favorites
                
                // see if we want to add or remove a follower
                switch actionType {
                    
                case .add:
                    // see if follwer is alreay added to array
                    guard !retrievedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    // if user isn't in array of favorites
                    retrievedFavorites.append(favorite)
                    
                case .remove:
                    // if we want to remove, remove all items with same login with passed user
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                
                // call function to save the updated favorites Array
                completed(save(favorites: retrievedFavorites))
                
                
            case .failure(let error):
                // if error pass the error we get from the retrieveFavorites function
                completed(error)
            }
        }
    }
    
    
    // MARK: Get Favorites Decoder
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        // tell it what our saved data is named so he can go and look for it in the defaults
        // -- as? Data -- Casting the value of the saved data as Data
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            // if vlue is nil means that we haven't saved there before so we return an empty array
            completed(.success([]))
            return
        }
        
        // If data exists in defaults decode it and place it in an array of time [Follower]
        do {
            let decoder = JSONDecoder()
            // array we want to create          its type        from the favoritesData constant from above
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            // if all ok call the completed callback, passing the array and nil for error
            completed(.success(favorites))
        } catch {
            // if the decoder above throws
            completed(.failure(.unableToFavorite))
        }
    }
    
    
    // MARK: Set Favorites Encoder
    // Encode and save data to User Defaults --> Optionally can return error if encoding isn't working
    static func save(favorites: [Follower]) -> GFError? {
        do {
            // set encode
            let encoder = JSONEncoder()
            // encode incoming data
            let encodedFavorites = try encoder.encode(favorites)
            // save data to User Defaults
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
}

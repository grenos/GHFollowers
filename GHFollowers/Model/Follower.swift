//
//  Follower.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 25/03/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import Foundation

// when we use codable we need to name our variables with the same names that we get from the API
// BUT we can chanhe the names of the variables from snake_case to camelCase ** avatar_url --> avatarUrl ** codable will take care of this
// here we conform to the Codable protocol because we are using it on the network calls

// We use the Follower object with the diffable data source so it needs to conform to Hashable
struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String
}

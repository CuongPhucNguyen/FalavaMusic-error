//
//  User.swift
//  Kimusic
//
//  Created by Hieu Le Pham Ngoc on 31/08/2022.
//

import Foundation


public struct AppUser: Codable {
    let name: String
    let photoURL: String?
    let email: String?
    let followers: Int64?
    let following: Int64?
    let friendList: [String]?
    let playlists: [String : [String]]?
    

    enum CodingKeys: String, CodingKey {
        case name
        case photoURL
        case email
        case followers
        case following
        case friendList
        case playlists
    }

}

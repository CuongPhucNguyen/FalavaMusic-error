//
//  ListenModel.swift
//  Kimusic
//
//  Created by dat huynh on 30/07/2022.
//

import Foundation

import Foundation

// MARK: - ZingListen
struct ZingListen: Codable {
    let err: Int?
    let msg: String?
    let data: DataClassMusic?
    let timestamp: Int?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - DataClass
struct DataClassMusic: Codable {
    let the128: String?
    let the320: String?

    enum CodingKeys: String, CodingKey {
        case the128 = "128"
        case the320 = "320"
    }
}

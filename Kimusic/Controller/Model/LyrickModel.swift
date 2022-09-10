//
//  LyrickModel.swift
//  Kimusic
//
//  Created by Dat Huynh Dac Tan on 10/09/2022.


import Foundation
// MARK: - Lyrick
struct LyrickModel: Codable, Hashable {
    var err: Int?
    var msg: String?
    var data: DataClassLyrick?
    var timestamp: Int?
}


// MARK: - DataClass
struct DataClassLyrick: Codable, Hashable {
    var sentences: [Sentence]?
    var file: String?
    var enabledVideoBG: Bool?
    var defaultIBGUrls: [String]?
    var defaultVBGUrls: [String]?
    var bgMode: Int?

    enum CodingKeys: String, CodingKey {
        case sentences, file, enabledVideoBG, defaultIBGUrls, defaultVBGUrls
        case bgMode = "BGMode"
    }
}


// MARK: - Sentence
struct Sentence: Codable, Hashable {
    var words: [Word]?
}

// MARK: - Word
struct Word: Codable, Hashable {
    var startTime, endTime: Int?
    var data: String?
}

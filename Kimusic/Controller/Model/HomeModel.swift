//
//  HomeModel.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import Foundation

// MARK: - ZingHome
struct ZingHome: Codable, Hashable {
    let err: Int?
    let msg: String?
    let data: DataClass?
    let timestamp: Int?
}


// MARK: - DataClass
struct DataClass: Codable, Hashable {
    let items: [DataItem]?
    let hasMore: Bool?
    let total: Int?
}

// MARK: - DataItem
struct DataItem: Codable, Hashable {
    let sectionType, viewType, title, link: String?
    let sectionId: String?
    let items: [ItemItem]?
    let adId, pageType, itemType: String?
}

// MARK: - ItemItem
struct ItemItem: Codable, Hashable {
    let type: TypeUnion?
    let link: String?
    let externalLink: Bool?
    let banner, cover: String?
    let target, title, itemDescription: String?
    let ispr: Int?
    let encodeId: String?
    let thumbnail: String?
    let isoffical, isIndie: Bool?
    let releaseDate, sortDescription: String?
    let genreIds: [String]?
    let pr: Bool?
    let artists: [AlbumArtist]?
    let artistsNames: String?
    let playItemMode, subType, uid: Int?
    let thumbnailM: String?
    let isShuffle, isPrivate: Bool?
    let userName: String?
    let isAlbum: Bool?
    let textType: String?
    let isSingle: Bool?
    let zoneid: String?
    let song: [Song]?
    let album: [AlbumElement]?
    let isDailymix: Bool?
    let thumbnails: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type, link, externalLink, banner, cover, target, title
        case itemDescription = "description"
        case ispr, encodeId, thumbnail, isoffical, isIndie, releaseDate, sortDescription, genreIds
        case pr = "PR"
        case artists, artistsNames, playItemMode, subType, uid, thumbnailM, isShuffle, isPrivate, userName, isAlbum, textType, isSingle, zoneid, song, album, isDailymix, thumbnails
    }
}

// MARK: - AlbumElement
struct AlbumElement: Codable, Hashable {
    let encodeId, title: String?
    let thumbnail: String?
    let isoffical: Bool?
    let link: String?
    let isIndie: Bool?
    let releaseDate, sortDescription: String?
    let genreIds: [String]?
    let pr: Bool?
    let artists: [AlbumArtist]?
    let artistsNames: String?
    let playItemMode, subType, uid: Int?
    let thumbnailM: String?
    let isShuffle, isPrivate: Bool?
    let userName: String?
    let isAlbum: Bool?
    let textType: String?
    let isSingle: Bool?
    
    enum CodingKeys: String, CodingKey {
        case encodeId, title, thumbnail, isoffical, link, isIndie, releaseDate, sortDescription, genreIds
        case pr = "PR"
        case artists, artistsNames, playItemMode, subType, uid, thumbnailM, isShuffle, isPrivate, userName, isAlbum, textType, isSingle
    }
}

// MARK: - AlbumArtist
struct AlbumArtist: Codable, Hashable {
    let id, name, link: String?
    let spotlight: Bool?
    let alias: String?
    let thumbnail, thumbnailM: String?
    let isOa, isOaBrand: Bool?
    let playlistId: String?
    let totalFollow: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, spotlight, alias, thumbnail, thumbnailM
        case isOa = "isOA"
        case isOaBrand = "isOABrand"
        case playlistId, totalFollow
    }
}

// MARK: - Song
struct Song: Codable, Hashable {
    let encodeId, title, alias: String?
    let isOffical: Bool?
    let username, artistsNames: String?
    let artists: [SongArtist]?
    let isWorldWide: Bool?
    let thumbnailM: String?
    let link: String?
    let thumbnail: String?
    let duration: Int?
    let zingChoice, isPrivate, preRelease: Bool?
    let releaseDate: Int?
    let genreIds: [String]?
    let album: SongAlbum?
    let indicators: [String]?
    let isIndie: Bool?
    let streamingStatus: Int?
    let allowAudioAds, hasLyric: Bool?
    let mvlink: String?
}

// MARK: - SongAlbum
struct SongAlbum: Codable, Hashable {
    let encodeId, title: String?
    let thumbnail: String?
    let isoffical: Bool?
    let link: String?
    let isIndie: Bool?
    let releaseDate, sortDescription: String?
    let genreIds: [String]?
    let pr: Bool?
    let artists: [AlbumArtist]?
    let artistsNames: String?
    
    enum CodingKeys: String, CodingKey {
        case encodeId, title, thumbnail, isoffical, link, isIndie, releaseDate, sortDescription, genreIds
        case pr = "PR"
        case artists, artistsNames
    }
}


// MARK: - SongArtist
struct SongArtist: Codable, Hashable {
    let id, name, link: String?
    let spotlight: Bool?
    let alias: String?
    let thumbnail, thumbnailM: String?
    let isOa, isOaBrand: Bool?
    let playlistId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, spotlight, alias, thumbnail, thumbnailM
        case isOa = "isOA"
        case isOaBrand = "isOABrand"
        case playlistId
    }
}
enum TypeUnion: Codable, Hashable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(TypeUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TypeUnion"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

//Page 2

// MARK: - ZingHome2
struct ZingHome2: Codable {
    let err: Int?
    let msg: String?
    let data: DataClass2?
    let timestamp: Int?
}

// MARK: - DataClass
struct DataClass2: Codable {
    let items: [DataItem2]?
    let hasMore: Bool?
    let total: Int?
}

// MARK: - DataItem
struct DataItem2: Codable {
    let sectionType, viewType, title, link: String?
    let sectionId: String?
    let items: [ItemItem2]?
    let subTitle: SubTitle2?
    let isShuffle: Bool?
    let chart: Chart?
    let chartType: String?
}

// MARK: - Chart
struct Chart: Codable {
    let times: [Time]?
    let minScore: Int?
    let maxScore: Double?
    let items: Items?
    let totalScore: Int?
}

// MARK: - Items
struct Items: Codable {
    let zzdfbfd8, zzeeocfz, zzeeuzwo: [Zzdfbfd8]?
    
    enum CodingKeys: String, CodingKey {
        case zzdfbfd8
        case zzeeocfz
        case zzeeuzwo
    }
}

// MARK: - Zzdfbfd8
struct Zzdfbfd8: Codable {
    let time: Int?
    let hour: String?
    let counter: Int?
}

// MARK: - Time
struct Time: Codable {
    let hour: String?
}

// MARK: - ItemItem
struct ItemItem2: Codable {
    let encodeId, title: String?
    let thumbnail: String?
    let isoffical: Bool?
    let link: String?
    let isIndie: Bool?
    let releaseDate: ReleaseDate?
    let sortDescription: String?
    let genreIds: [String]?
    let pr: Bool?
    let artists: [PurpleArtist]?
    let artistsNames: String?
    let playItemMode, subType, uid: Int?
    let thumbnailM: String?
    let isShuffle, isPrivate: Bool?
    let userName: String?
    let isAlbum: Bool?
    let textType: String?
    let isSingle: Bool?
    let song: Song2?
    let alias: String?
    let isOffical: Bool?
    let username: String?
    let isWorldWide: Bool?
    let duration: Int?
    let zingChoice, preRelease: Bool?
    let album: PurpleAlbum2?
    let indicators: [JSONAny]?
    let streamingStatus: Int?
    let allowAudioAds, hasLyric: Bool?
    let rakingStatus, score, totalTopZing: Int?
    let artist: FluffyArtist?
    
    enum CodingKeys: String, CodingKey {
        case encodeId, title, thumbnail, isoffical, link, isIndie, releaseDate, sortDescription, genreIds
        case pr
        case artists, artistsNames, playItemMode, subType, uid, thumbnailM, isShuffle, isPrivate, userName, isAlbum, textType, isSingle, song, alias, isOffical, username, isWorldWide, duration, zingChoice, preRelease, album, indicators, streamingStatus, allowAudioAds, hasLyric, rakingStatus, score, totalTopZing, artist
    }
}

// MARK: - PurpleAlbum
struct PurpleAlbum2: Codable {
    let encodeId, title: String?
    let thumbnail: String?
    let isoffical: Bool?
    let link: String?
    let isIndie: Bool?
    let releaseDate, sortDescription: String?
    let genreIds: [String]?
    let pr: Bool?
    let artists: [PurpleArtist2]?
    let artistsNames: String?
    
    enum CodingKeys: String, CodingKey {
        case encodeId, title, thumbnail, isoffical, link, isIndie, releaseDate, sortDescription, genreIds
        case pr
        case artists, artistsNames
    }
}

// MARK: - PurpleArtist
struct PurpleArtist2: Codable {
    let id, name, link: String?
    let spotlight: Bool?
    let alias: String?
    let thumbnail, thumbnailM: String?
    let isOa, isOaBrand: Bool?
    let playlistId: String?
    let totalFollow: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, spotlight, alias, thumbnail, thumbnailM
        case isOa
        case isOaBrand
        case playlistId, totalFollow
    }
}

// MARK: - FluffyArtist
struct FluffyArtist: Codable {
    let id, name, link: String?
    let spotlight: Bool?
    let alias, playlistId: String?
    let cover: String?
    let thumbnail: String?
}

enum ReleaseDate: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(ReleaseDate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ReleaseDate"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Song
struct Song2: Codable {
    let total: Int?
    let items: [SongItem]?
}

// MARK: - SongItem
struct SongItem: Codable {
    let encodeId, title, alias: String?
    let isOffical: Bool?
    let username, artistsNames: String?
    let artists: [StickyArtist]?
    let isWorldWide: Bool?
    let thumbnailM: String?
    let link: String?
    let thumbnail: String?
    let duration: Int?
    let zingChoice, isPrivate, preRelease: Bool?
    let releaseDate: Int?
    let genreIds: [String]?
    let album: FluffyAlbum?
    let indicators: [String]?
    let isIndie: Bool?
    let streamingStatus: Int?
    let allowAudioAds, hasLyric: Bool?
    let radioId: Int?
    let mvlink: String?
}

// MARK: - FluffyAlbum
struct FluffyAlbum: Codable {
    let encodeId, title: String?
    let thumbnail: String?
    let isoffical: Bool?
    let link: String?
    let isIndie: Bool?
    let releaseDate, sortDescription: String?
    let genreIds: [String]?
    let pr: Bool?
    let artists: [TentacledArtist]?
    let artistsNames: String?
    
    enum CodingKeys: String, CodingKey {
        case encodeId, title, thumbnail, isoffical, link, isIndie, releaseDate, sortDescription, genreIds
        case pr
        case artists, artistsNames
    }
}

// MARK: - TentacledArtist
struct TentacledArtist: Codable {
    let id, name, link: String?
    let spotlight: Bool?
    let alias: String?
    let thumbnail, thumbnailM: String?
    let isOa, isOaBrand: Bool?
    let playlistId: String?
    let totalFollow: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, spotlight, alias, thumbnail, thumbnailM
        case isOa
        case isOaBrand
        case playlistId, totalFollow
    }
}

// MARK: - StickyArtist
struct StickyArtist: Codable {
    let id, name, link: String?
    let spotlight: Bool?
    let alias: String?
    let thumbnail, thumbnailM: String?
    let isOa, isOaBrand: Bool?
    let playlistId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, spotlight, alias, thumbnail, thumbnailM
        case isOa
        case isOaBrand
        case playlistId
    }
}

// MARK: - SubTitle
struct SubTitle2: Codable {
    let encodeId, title: String?
    let thumbnail: String?
    let isoffical: Bool?
    let link: String?
    let isIndie: Bool?
    let releaseDate, sortDescription: String?
    let genreIds: [String]?
    let pr: Bool?
    let artists: [SubTitleArtist]?
    let artistsNames, id, name: String?
    let spotlight: Bool?
    let alias: String?
    let thumbnailM: String?
    let isOa, isOaBrand: Bool?
    let playlistId: String?
    
    enum CodingKeys: String, CodingKey {
        case encodeId, title, thumbnail, isoffical, link, isIndie, releaseDate, sortDescription, genreIds
        case pr
        case artists, artistsNames, id, name, spotlight, alias, thumbnailM
        case isOa
        case isOaBrand
        case playlistId
    }
}

// MARK: - SubTitleArtist
struct SubTitleArtist: Codable {
    let id, name, link: String?
    let spotlight: Bool?
    let alias: String?
    let thumbnail, thumbnailM: String?
    let isOa, isOaBrand: Bool?
    let totalFollow: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, link, spotlight, alias, thumbnail, thumbnailM
        case isOa
        case isOaBrand
        case totalFollow
    }
}


class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONAny: Codable {
    
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

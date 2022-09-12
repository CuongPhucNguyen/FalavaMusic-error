// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchResultsModel = try? newJSONDecoder().decode(SearchResultsModel.self, from: jsonData)

import Foundation

// MARK: - SearchResultsModel
struct SearchResultsModel: Codable, Hashable {
    var err: Int?
    var msg: String?
    var data: DataClassResult?
    var timestamp: Int?
}

// MARK: - DataClassResult
struct DataClassResult: Codable, Hashable {
    var TopResult: TopResult?
    var artists: [DataArtist]?
    var SongResults: [SongResult]?
    var VideoResults: [VideoResult]?
    var playlists: [Playlist]?
    var counter: Counter?
    var sectionID: String?
}

// MARK: - DataArtist
struct DataArtist: Codable, Hashable {
    var id, name, link: String?
    var spotlight: Bool?
    var alias: String?
    var thumbnail, thumbnailM: String?
    var isOA, isOABrand: Bool?
    var playlistID: String?
    var totalFollow: Int?
}

// MARK: - Counter
struct Counter: Codable, Hashable {
    var SongResult, artist, playlist, VideoResult: Int?
}

// MARK: - Playlist
struct Playlist: Codable, Hashable {
    var encodeID, title: String?
    var thumbnail: String?
    var isoffical: Bool?
    var link: String?
    var isIndie: Bool?
    var releaseDate, sortDescription: String?
    var genreIDS: [String]?
    var pr: Bool?
    var artists: [DataArtist]?
    var artistsNames: String?
    var playItemMode, subType, uid: Int?
    var thumbnailM: String?
    var isShuffle, isPrivate: Bool?
    var userName: String?
    var isAlbumResult: Bool?
    var textType: String?
    var isSingle, isOwner, canEdit, canDelete: Bool?
}

// MARK: - SongResult
struct SongResult: Codable, Hashable {
    
    
    var encodeID, title, alias: String?
    var isOffical: Bool?
    var username, artistsNames: String?
    var artists: [SongArtistResult]?
    var isWorldWide: Bool?
    var thumbnailM: String?
    var link: String?
    var thumbnail: String?
    var duration: Int?
    var zingChoice, isPrivate, preRelease: Bool?
    var releaseDate: Int?
    var genreIDS: [String]?
    var AlbumResult: AlbumResult?
    var indicators: [String?]?
    var radioID: Int?
    var isIndie: Bool?
    var streamingStatus: Int?
    var allowAudioAds, hasLyric: Bool?
    var mvlink: String?
}

// MARK: - AlbumResult
struct AlbumResult: Codable, Hashable {
    var encodeID, title: String?
    var thumbnail: String?
    var isoffical: Bool?
    var link: String?
    var isIndie: Bool?
    var releaseDate, sortDescription: String?
    var genreIDS: [String]?
    var pr: Bool?
    var artists: [DataArtist]?
    var artistsNames: String?
}

// MARK: - SongArtistResult
struct SongArtistResult: Codable, Hashable {
    var id, name, link: String?
    var spotlight: Bool?
    var alias: String?
    var thumbnail, thumbnailM: String?
    var isOA, isOABrand: Bool?
    var playlistID: String?
}

// MARK: - TopResult
struct TopResult: Codable, Hashable {
    var encodeID, title, alias: String?
    var isOffical: Bool?
    var username, artistsNames: String?
    var artists: [TopResultArtist]?
    var isWorldWide: Bool?
    var thumbnailM: String?
    var link: String?
    var thumbnail: String?
    var duration: Int?
    var zingChoice, isPrivate, preRelease: Bool?
    var releaseDate: Int?
    var genreIDS: [String]?
    var indicators: [String?]?
    var radioID: Int?
    var isIndie: Bool?
    var streamingStatus: Int?
    var allowAudioAds, hasLyric: Bool?
    var objectType: String?
}

// MARK: - TopResultArtist
struct TopResultArtist: Codable, Hashable {
    var id, name, link: String?
    var spotlight: Bool?
    var alias: String?
    var thumbnail, thumbnailM: String?
    var isOA, isOABrand: Bool?
    var playlistID: String?
}

// MARK: - VideoResult
struct VideoResult: Codable, Hashable {
    var encodeID, title, alias: String?
    var isOffical: Bool?
    var username, artistsNames: String?
    var artists: [SongArtistResult]?
    var isWorldWide: Bool?
    var thumbnailM: String?
    var link: String?
    var thumbnail: String?
    var duration, streamingStatus: Int?
    var artist: PurpleArtistResult?
}

// MARK: - PurpleArtistResult
struct PurpleArtistResult: Codable, Hashable {
    var id, name, link: String?
    var spotlight: Bool?
    var alias, playlistID: String?
    var cover, thumbnail: String?
}

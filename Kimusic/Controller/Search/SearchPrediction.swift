import Foundation

// MARK: - Prediction
struct Prediction: Codable, Hashable{
    var err: Int?
    var msg: String?
    var sTime: Int?
    var data: DataClassPrediction?
}


// MARK: - DataClass
struct DataClassPrediction: Codable, Hashable {
    var items: [ItemPrediction]?
}

// MARK: - Item
struct ItemPrediction: Codable, Hashable {
    var keywords: [Keyword]?
    var itemSuggestions: [Suggestion]?
}

// MARK: - Keyword
struct Keyword: Codable, Hashable {
    var type: Int?
    var keyword: String?
    var suggestType: Int?
}

// MARK: - Suggestion
struct Suggestion: Codable, Hashable {
    var type: Int?
    var title, id, radioPID: String?
    var hasVideo: Bool?
    var thumb: String?
    var thumbVideo: String?
    var duration, status, playStatus: Int?
    var artists: [Artist]?
    var genres: [GenrePrediction]?
    var disSPlatform, disDPlatform, boolAtt: Int?
    var rbt: Rbt?
    var user: User?
    var isPR, isAlbum: Bool?
    var artistType: Int?
    var name, aliasName, avatar: String?
    var followers: Int?

    enum CodingKeys: String, CodingKey {
        case type, title, id
        case radioPID = "radioPid"
        case hasVideo, thumb, thumbVideo, duration, status, playStatus, artists, genres, disSPlatform, disDPlatform, boolAtt, rbt, user, isPR, isAlbum, artistType, name, aliasName, avatar, followers
    }
}
// MARK: - Artist
struct Artist: Codable, Hashable {
    var aliasName, name, id: String?
}


// MARK: - Genre
struct GenrePrediction: Codable, Hashable {
    var name, id: String?
}
// MARK: - Rbt
struct Rbt: Codable, Hashable {
    var link: String?
    var boolAtt: Int?
}
// MARK: - User
struct User: Codable, Hashable {
    var id: Int?
    var euID, name: String?
    var avatar: String?
    var createdTime, boolAtt: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case euID = "euId"
        case name, avatar, createdTime, boolAtt
    }
}


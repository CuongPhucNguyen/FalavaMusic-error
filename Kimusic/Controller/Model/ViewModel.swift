//
//  ViewModel.swift
//  Kimusic
//
//  Created by dat huynh on 01/08/2022.
//
import SwiftUI

enum APIError: Error {
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}

enum APIState {
    case loading
    case success
    case failure(APIError)
}


enum MusicType: String{
    case Song = "Song"
    case Album = "Album"
    case all = "ALL"
}

struct MusicModel: Equatable, Decodable, Encodable {
    var idCode : String = ""
    var MusicTitle : String = ""
    var MusicBanner: String = ""
    var ArtistName: String = ""
    
    var id = UUID().uuidString
}

class MusicSessionManager {
    // MARK:- Properties

    public static var shared = MusicSessionManager()
    
    var MusicTabManger: MusicModel {
        get {
            guard let data = UserDefaults.standard.data(forKey: "Music") else { return MusicModel() }
            return (try? JSONDecoder().decode(MusicModel.self, from: data)) ?? MusicModel()
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "Music")
        }
    }
    func refresh() {
        
    }
    
    // MARK:- Init
    private init(){}
}

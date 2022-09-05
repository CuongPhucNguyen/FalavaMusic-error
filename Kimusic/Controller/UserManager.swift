//
//  UserManager.swift
//  Kimusic
//
//  Created by dat huynh on 01/09/2022.
//

import Foundation


class MusicSessionManager {
    // MARK:- Properties
    
    public static var shared = MusicSessionManager()
    
    var MusicTabManger: [MusicModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "Music") else { return [] }
            return (try? JSONDecoder().decode([MusicModel].self, from: data)) ?? []
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


struct MusicModel: Identifiable, Decodable, Encodable {
    
    var idCode : String
    var MusicTitle : String
    var MusicBanner: String
    var ArtistName: String
    
    var showTab : Bool = false

    var id = UUID().uuidString
    
}

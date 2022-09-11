//
//  ZingStruct.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import Foundation


struct ZingStruct{
    let zingVersion : String = "1.7.11"
    
    let ApiKey : String = "X5BM3w8N7MKozC0B85o4KMlzLZKhV00y" // X5BM3w8N7MKozC0B85o4KMlzLZKhV00y
    let secret : String = "acOrvUS15XRW2o9JksiK1KgQ6Vbds8ZW" // acOrvUS15XRW2o9JksiK1KgQ6Vbds8ZW
    
    let domain : String = "https://zingmp3.vn"
    
    
    let Radio : String = "/api/v2/page/get/radio"
    
    let homePage : String = "/api/v2/page/get/home"
    let PlayList : String = "/api/v2/page/get/playlist"
    
    let Listen: String = "/api/v2/song/get/streaming"
    
    let lyrick : String = "/api/v2/lyric/get/lyric"
    
    let SearchResults : String = "/api/v2/search/multi"
}

class ZingCollectorLink {
    
    let zingClass = SecurityHash()
        
    
    func getHomePage(page: String) -> String {
        let timestamp : String = String(Date().currentTimeMillis()) // Ctime
        
        let Hash : String = "ctime=\(timestamp)page=\(page)version=\(ZingStruct().zingVersion)" // 256
        let Sig : String = zingClass.getFinalHash(hashValue: Hash, Slug: ZingStruct().homePage, Key: ZingStruct().secret) // 512
        let FinalLink = ZingStruct().domain+ZingStruct().homePage+"?page=\(page)&ctime=\(timestamp)&version=\(ZingStruct().zingVersion)&sig=\(Sig)&apiKey=\(ZingStruct().ApiKey)"
        return FinalLink
    }
    
    
    func getPlayList(id: String) -> String {
        let timestamp : String = String(Date().currentTimeMillis())
        
        let Hash : String = "ctime=\(timestamp)id=\(id)version=\(ZingStruct().zingVersion)" // 256
        
        let Sig : String = zingClass.getFinalHash(hashValue: Hash, Slug: ZingStruct().PlayList, Key: ZingStruct().secret) // 512
        
        
        let FinalLink = ZingStruct().domain+ZingStruct().PlayList+"?id=\(id)&ctime=\(timestamp)&version=\(ZingStruct().zingVersion)&sig=\(Sig)&apiKey=\(ZingStruct().ApiKey)"
        return FinalLink
    }
    
    func getMusicPlay(id: String) -> String {
        let timestamp : String = String(Date().currentTimeMillis())
        
        let Hash : String = "ctime=\(timestamp)id=\(id)version=\(ZingStruct().zingVersion)"
        
        let Sig : String = zingClass.getFinalHash(hashValue: Hash, Slug: ZingStruct().Listen, Key: ZingStruct().secret)
        let FinalLink = ZingStruct().domain+ZingStruct().Listen+"?id=\(id)&ctime=\(timestamp)&version=\(ZingStruct().zingVersion)&sig=\(Sig)&apiKey=\(ZingStruct().ApiKey)"
        return FinalLink
    }
    
    func getLyrick(idMusic: String) -> String {
        let timestamp : String = String(Date().currentTimeMillis())
        
        let Hash : String = "ctime=\(timestamp)id=\(idMusic)version=\(ZingStruct().zingVersion)"
        
        let Sig : String = zingClass.getFinalHash(hashValue: Hash, Slug: ZingStruct().lyrick, Key: ZingStruct().secret)
        let FinalLink = ZingStruct().domain+ZingStruct().lyrick+"?id=\(idMusic)&ctime=\(timestamp)&version=\(ZingStruct().zingVersion)&sig=\(Sig)&apiKey=\(ZingStruct().ApiKey)"
        return FinalLink
    }
    func getSearchResults(searchValue: String) -> String {
        let timestamp : String = String(Date().currentTimeMillis())
        
        let Hash : String = "ctime=\(timestamp)version=\(ZingStruct().zingVersion)"
        
        let Sig : String = zingClass.getFinalHash(hashValue: Hash, Slug: ZingStruct().SearchResults, Key: ZingStruct().secret)
        let FinalLink = ZingStruct().domain+ZingStruct().SearchResults+"?q=\(searchValue)&ctime=\(timestamp)&version=\(ZingStruct().zingVersion)&sig=\(Sig)&apiKey=\(ZingStruct().ApiKey)"
        return FinalLink
    }
}

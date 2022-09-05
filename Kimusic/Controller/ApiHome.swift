//
//  ApiHome.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import Foundation


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


class SongListViewModel: ObservableObject{
    let ZingClass = ZingCollectorLink();
    
    @Published var apiState: APIState = .loading
    
    
    //MARK: - For Data Page 1
    @Published var AlbumNews : [AlbumElement] = []
    @Published var SongNews : [Song] = []
    @Published var Chill : [ItemItem] = []
    @Published var WantToListen : [ItemItem] = []
    @Published var Banner : [ItemItem] = []
    @Published var MixForYou : [ItemItem] = []
    
    @Published var MusicPage : MusicType = .Song
    @Published var MusicCheck : Bool = true
        
    
    //MARK: - For Data Page 2
    
    @Published var AlreadyListen : [ItemItem2] = []
    @Published var ForFan : [ItemItem2] = []
    @Published var newDay: [ItemItem2] = []
    
    
    
    //MARK: - For Cookies config
    var cookieZmp3_sid = HTTPCookie(properties: [
        .name: "zmp3_sid",
        .value: "a_2pQVv9J5MDzRHe_KXLNuxjrnQz3ajuby7k784kQ63pvz48mnzMU_QvzqdxO7nqw8R7GkOuMnBhokHZy2zI3-lfwcFX8KnUm-xfEjD6N5BW_imaQMG",
        .domain: ".zingmp3.vn",
        .path: "/",
    ])!
    
    var cookieZpsid = HTTPCookie(properties: [
        .name: "zpsid",
        .value: "j9Ky.209077836.20.MLphSkiDjaUdIy1BvmssHvv-n7NRD8Pmt3M5SUNyptXnyiXMwiICi8aDjaS",
        .domain: ".zingmp3.vn",
        .path: "/",
    ])!
    let cs = HTTPCookieStorage.shared
    
    @MainActor
    func executedZing() async {
        let linkPage1 = ZingClass.getHomePage(page: "1")
        let linkPage2 = ZingClass.getHomePage(page: "2")
        
        
        
        
        
        
        apiState = .loading
        
        Banner = await decoceZingBanner(JsonUrl: linkPage1)
        SongNews = await decoceZingSongElement(JsonUrl: linkPage1)
        
        WantToListen = await decoceZingWantToListion(JsonUrl: linkPage1)
        Chill = await decoceZingChill(JsonUrl: linkPage1)
        AlbumNews = await decoceZingAlbumElement(JsonUrl: linkPage1)
        MixForYou = await decoceZingMixForYou(JsonUrl: linkPage1)

        
        AlreadyListen = await decoceZingAlreadyListen(JsonUrl: linkPage2)
        ForFan = await decoceZingForFan(JsonUrl: linkPage2)
        newDay = await decoceZingNewsDay(JsonUrl: linkPage2)
        
        apiState = .success
    }
    
    //Page 1
    func decoceZingBanner(JsonUrl: String) async -> [ItemItem] {
        if let url = URL(string: JsonUrl) {
            cs.setCookies([cookieZmp3_sid, cookieZpsid], for: url, mainDocumentURL: nil)
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome.self, from: data) // ZingHome
                
                if(decoded.err == -201){
                    Task{
                        await decoceZingBanner(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![0].items!
                }
            
            } catch {
                apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingWantToListion(JsonUrl: String) async -> [ItemItem] {
        if let url = URL(string: JsonUrl) {
            cs.setCookies([cookieZmp3_sid, cookieZpsid], for: url, mainDocumentURL: nil)
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingWantToListion(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![3].items!
                }
            
            } catch {
                apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    
    func decoceZingChill(JsonUrl: String) async -> [ItemItem] {
        if let url = URL(string: JsonUrl) {
            cs.setCookies([cookieZmp3_sid, cookieZpsid], for: url, mainDocumentURL: nil)
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingChill(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![5].items!
                }
            
            } catch {
                apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingTopicToday(JsonUrl: String) async -> [ItemItem] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingTopicToday(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![4].items!
                }
            
            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingMixForYou(JsonUrl: String) async -> [ItemItem] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingTopicToday(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![6].items!
                }
            
            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingAlbumElement(JsonUrl: String) async -> [AlbumElement] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingAlbumElement(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![4].items![0].album!
                }

            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingSongElement(JsonUrl: String) async -> [Song] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingSongElement(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![4].items![0].song!
                }

            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingAlreadyListen(JsonUrl: String) async -> [ItemItem2] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome2.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingAlreadyListen(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![0].items!
                }
            
            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingForFan(JsonUrl: String) async -> [ItemItem2] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome2.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingForFan(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![1].items!
                }
            
            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    func decoceZingNewsDay(JsonUrl: String) async -> [ItemItem2] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingHome2.self, from: data)
                if(decoded.err == -201){
                    Task{
                        await decoceZingNewsDay(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![3].items!
                }
            
            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
}

//
//  ApiAlbums.swift
//  Kimusic
//
//  Created by dat huynh on 29/07/2022.
//
import Foundation

class AlbumFetchApi: ObservableObject{
    
    let ZingClass = ZingCollectorLink();
    
    
    @Published var apiState: APIState = .loading
    @Published var AlbumData : DataClassAlbum?
    
    
    @Published var ListMusic : [Item] = []
    
    @Published var TitleAlbum : String = ""
    @Published var BannerAlbum : String = ""
    
    
    init() {
        self.AlbumData = nil
    }
    
    @MainActor
    func ExecutedAlbum(idCode: String) async{
        apiState = .loading
        URLCache.shared.removeAllCachedResponses()
        
        
        AlbumData = await decoceZingtas(idCode: idCode)
        
        ListMusic = AlbumData!.song!.items!
        TitleAlbum = AlbumData!.title!
        BannerAlbum = AlbumData!.thumbnail!
        
        apiState = .success
    }
    
    
    // Crack
    func decoceZingtas(idCode: String) async ->  DataClassAlbum? {
        let linkAlbum = ZingClass.getPlayList(id: idCode)
        
        if let url = URL(string: linkAlbum) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingAlbum.self, from: data)
                
                if(decoded.err == -201){
                    Task{
                        await decoceZingtas(idCode: idCode)
                    }
                } else{
                    return decoded.data!
                }
            
            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return nil
    }
    
}

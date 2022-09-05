//
//  SearchController.swift
//  Kimusic
//
//  Created by Cuong Nguyen Phuc on 31/08/2022.
//

import Foundation





class SearchGetter: ObservableObject{
    var apiState: APIState = .loading
    var prediction: Prediction?
    
    
    
    func suggestion(JsonUrl: String) async -> [Suggestion] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(Prediction.self, from: data) // ZingHome
                if(decoded.err == -201){
                    Task{
                        await suggestion(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![0].suggestions!
                }
            
            } catch {
                apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    
    func keyword(JsonUrl: String) async -> [Keyword] {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(Prediction.self, from: data) // ZingHome
                
                if(decoded.err == -201){
                    Task{
                        await keyword(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded.data!.items![0].keywords!
                }
            
            } catch {
                apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return []
    }
    
    
    
    func getString(JsonUrl: String) async -> String{
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(Prediction.self, from: data) // ZingHome
                let _ = print(decoded)
                return ""
            
            } catch {
                apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return ""
    }
    
    
    func getAll(JsonUrl: String) async -> Prediction {
        if let url = URL(string: JsonUrl) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(Prediction.self, from: data) // ZingHome
                
                if(decoded.err == -201){
                    Task{
                        await keyword(JsonUrl: JsonUrl)
                    }
                } else{
                    return decoded
                }
            
            } catch {
                apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return Prediction.init()
    }
    
//    static func inputFormatter(keywords: String)->String{
//        var formattedKeywords = ""
//        for char in keywords{
//            if (char == " "){
//                formattedKeywords.append("%20")
//            }
//            else {
//                formattedKeywords.append(char)
//            }
//        }
//        return formattedKeywords
//    }
    
    static func inputFormatter(keywords: String)->String{
        return keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    
    
    
    
    
    
    
    init(){
    }
    
    
    


}





extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .unicode)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    func utf16EncodedString()-> String {
        let messageData = self.data(using: .unicode)
        let text = String(data: messageData!, encoding: .utf16) ?? ""
        return text
    }
    func unicodeEncodedString()-> String {
        let messageData = self.data(using: .utf16)
        let text = String(data: messageData!, encoding: .unicode) ?? ""
        return text
    }
    func utf16ToUtf8EncodedString()-> String {
        let messageData = self.data(using: .utf16)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    
    
//    func toUTF()->String{
//        return String(UTF8String: self.data.cStringUsingEncoding(NSUTF8StringEncoding))
//    }
    
}

//
//  ApiHome.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//


import Foundation
import AVKit
import MediaPlayer
import Combine
import SwiftUI


final class TopLevelController: ObservableObject{
    let ZingClass = ZingCollectorLink();
    @Published var apiState: APIState = .loading
    var cancellables = Set<AnyCancellable>()
    
    
    //MARK: - For Data Page 1
    @Published var AlbumNews : [AlbumElement] = []
    @Published var SongNews : [Song] = []
    
    @Published var Chill : [ItemItem] = []
    @Published var WantToListen : [ItemItem] = []
    @Published var Banner : [ItemItem] = []
    @Published var MixForYou : [ItemItem] = []
    
    @Published var MusicPage : MusicType = .Song
    @Published var MusicCheck : Bool = true
    
    
    //MARK: - For Data Page
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
    
    
    
    //MARK: Grab all data and Display in Home
    @MainActor
    func executedZing() async {
        let linkPage1 = ZingClass.getHomePage(page: "1")
        let linkPage2 = ZingClass.getHomePage(page: "2")
        
        apiState = .loading
        await decoceZingPage1(JsonUrl: linkPage1)
        await decoceZingPage2(JsonUrl: linkPage2)
        apiState = .success
    }
    
    func decoceZingPage1(JsonUrl : String) async {
        guard let url = URL(string: JsonUrl) else { return }
        
        cs.setCookies([cookieZmp3_sid, cookieZpsid], for: url, mainDocumentURL: nil)
        let request = URLRequest(url: url)
        
        //1. create a publisher
        //2. subcribe the publisher on background thread
        //3. receive on main thread
        //4. tryMap (check the data)
        //5. decode data (decode data into PostModel with JSONDecoder())
        //6. replace error with nil data
        //7. sink (get and put items into app)
        //8. store (cancel subscription if needed)
        
        URLSession.shared.dataTaskPublisher(for: request) //1
            .subscribe(on: DispatchQueue.global(qos: .background)) //2
            .receive(on: DispatchQueue.main) //3
            .tryMap { (data, response) -> Data in //4
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ZingHome.self, decoder: JSONDecoder()) //5
            .sink { (completion) in //7
                print("completion: \(completion)")
            } receiveValue: { decoded in
                if(decoded.err == -201){
                    Task {
                        await self.decoceZingPage1(JsonUrl: JsonUrl)
                    }
                } else {
                    Task.detached(priority: .high) {
                        DispatchQueue.main.async {
                            self.Banner = decoded.data!.items![0].items!
                            self.SongNews = decoded.data!.items![4].items![0].song!
                            self.WantToListen = decoded.data!.items![3].items!
                            self.Chill = decoded.data!.items![5].items!
                            self.MixForYou = decoded.data!.items![6].items!
                            self.AlbumNews = decoded.data!.items![4].items![0].album!
                        }
                    }
                }
            }
            .store(in: &cancellables) //8
    }
    
    func decoceZingPage2(JsonUrl : String) async {
        guard let url = URL(string: JsonUrl) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ZingHome2.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("completion: \(completion)")
            } receiveValue: { decoded in
                if(decoded.err == -201) {
                    Task{
                        await self.decoceZingPage2(JsonUrl: JsonUrl)
                    }
                } else {
                    Task.detached(priority: .high) {
                        DispatchQueue.main.async{
                            self.AlreadyListen = decoded.data!.items![0].items!
                            self.ForFan = decoded.data!.items![1].items!
                            self.newDay = decoded.data!.items![3].items!
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    
    
    
    
    @Published var AlbumData : DataClassAlbum?
    
    
    @Published var ListMusic : [Item] = []
    @Published var TitleAlbum : String = ""
    @Published var BannerAlbum : String = ""
    
    //MARK: Album Api
    
    //MARK: - For Fetch Api from Albums
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
    
    
    
    //MARK: - For Executed Albums Data Api from Albums
    @MainActor
    func ExecutedAlbum(idCode: String) async{
        apiState = .loading
        
        AlbumData = await decoceZingtas(idCode: idCode)
        
        ListMusic = AlbumData!.song!.items!
        TitleAlbum = AlbumData!.title!
        BannerAlbum = AlbumData!.thumbnail!
        
        apiState = .success
    }
    
    //MARK: - MusicData
    @Published var MusicLink : String = ""
    @Published var CheckingPlay : Bool = false
    @Published var audioPlayer: AVAudioPlayer?
    @Published var audioTime : Double = 0
    
    @Published var TimeLyric : Int  = 0
    
    
    
    @Published private(set) var MusicTabBar: MusicModel?
    
    func updateMusicValue(MusicData: MusicModel) async {
        withAnimation(.linear){
            MusicTabBar = MusicModel(idCode: MusicData.idCode, MusicTitle: MusicData.MusicTitle, MusicBanner: MusicData.MusicBanner, ArtistName: MusicData.ArtistName)
            Task {
                await executedMusic()
            }
        }
    }
    
    
    @MainActor
    func executedMusic() async {
        apiState = .loading
        
        MusicLink = await decoceZingMusicLink(idCode: MusicTabBar!.idCode)!
        audioPlayer = await getDataPlayer(sound: MusicLink)
        
        audioPlayer!.isMeteringEnabled = true
        setupRemoteTransportControls()
        setupNowPlaying(audioPlayer: audioPlayer!, MusicName: MusicTabBar!.MusicTitle, MusicImage: LoadImage(Url: MusicTabBar!.MusicBanner)!, MusicArtist: MusicTabBar!.ArtistName)
        
        apiState = .success
    }
    
    
    
    
    //MARK: FOR Loading Image
    func LoadImage(Url: String) -> UIImage? {
        let url = URL(string: Url)!
        if let data = try? Data(contentsOf: url){
            return UIImage(data: data)!
        }
        return nil
    }
    
    
    //MARK: For Grab Music Link
    func decoceZingMusicLink(idCode: String) async ->  String? {
        let linkMusic = ZingClass.getMusicPlay(id: idCode)
        if let url = URL(string: linkMusic) {
            let request = URLRequest(url: url)
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.error("Link Repose Fail")
                }
                let decoded = try JSONDecoder().decode(ZingListen.self, from: data)
                
                if(decoded.err == -201){
                    Task {
                        await decoceZingMusicLink(idCode: idCode)
                    }
                } else{
                    return decoded.data!.the320!
                }
                
            } catch {
                self.apiState = .failure(APIError.error(error.localizedDescription))
            }
        }
        return ""
    }
    
    
    //MARK: For Grab Audio Player
    func getDataPlayer(sound: String) async -> AVAudioPlayer? {
        guard let url = URL(string: sound) else {
            print("Wrong Music Link")
            return nil
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            
            let soundData = try Data(contentsOf: url)
            let audioPlayer = try! AVAudioPlayer(data: soundData)
            
            await UIApplication.shared.beginReceivingRemoteControlEvents()
            
            let commandCenter = MPRemoteCommandCenter.shared()
            commandCenter.nextTrackCommand.isEnabled = true
            
            return audioPlayer
        } catch {
            print("Load Music Fail \(error)")
        }
        return nil
    }
    
    
    
    //MARK: For Play / Pause function
    func play(){
        if audioPlayer!.isPlaying{audioPlayer?.pause()}
        else{audioPlayer?.play()}
        CheckingPlay = audioPlayer!.isPlaying
    }
    
    
    //MARK: For Play / Pause but in Background
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if !self.audioPlayer!.isPlaying {
                self.play()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.audioPlayer!.isPlaying {
                self.audioPlayer!.pause()
                return .success
            }
            return .commandFailed
        }
    }
    
    
    
    
    
    //MARK: Controll time
    func updateTimer() {
        let currentTime = audioPlayer!.currentTime
        let total = audioPlayer!.duration
        let progress = currentTime / total
        
        withAnimation(.linear(duration: 0.1)) {
            self.audioTime = Double(progress)
        }
        CheckingPlay = audioPlayer!.isPlaying
    }
    
    func updateSilder(newTime: Double){
        if CheckingPlay == true {
            withAnimation(Animation.linear(duration: 0.1)){
                audioPlayer!.pause()
                audioPlayer!.currentTime = Double(newTime) * audioPlayer!.duration
            }
        }
        
        if CheckingPlay == false {
            withAnimation(Animation.linear(duration: 0.1)){
                audioPlayer?.play()
                CheckingPlay = true
            }
        }
    }
    
    //MARK: Get Current Time
    func getCurrentTime(value: TimeInterval)->String {
        return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
    }
    
    
    //MARK: Settup BackGround Music
    func setupNowPlaying(audioPlayer: AVAudioPlayer, MusicName: String, MusicImage: UIImage, MusicArtist: String) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = MusicName
        
        
        nowPlayingInfo[MPMediaItemPropertyArtwork] =
        MPMediaItemArtwork(boundsSize: MusicImage.size) { size in
            return MusicImage
        }
        
        
        nowPlayingInfo[MPMediaItemPropertyArtist] = MusicArtist
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    //MARK: Settup BackGround Music in Notification
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: AVAudioSession.interruptionNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(handleRouteChange),
                                       name: AVAudioSession.routeChangeNotification,
                                       object: nil)
    }
    
    //MARK: Handle music while someone call you
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        if type == .began {
            print("Interruption began")
            // Interruption began, take appropriate actions
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                    print("Interruption Ended - playback should resume")
                    play()
                } else {
                    // Interruption Ended - playback should NOT resume
                    print("Interruption Ended - playback should NOT resume")
                }
            }
        }
    }
    
    //MARK: Handle music while you connect headphones
    @objc func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
            return
        }
        switch reason {
        case .newDeviceAvailable:
            let session = AVAudioSession.sharedInstance()
            for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.headphones {
                print("headphones connected")
                DispatchQueue.main.sync {
                    self.play()
                }
                break
            }
        case .oldDeviceUnavailable:
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for output in previousRoute.outputs where output.portType == AVAudioSession.Port.headphones {
                    print("headphones disconnected")
                    DispatchQueue.main.sync {
                        self.audioPlayer?.pause()
                    }
                    break
                }
            }
        default: ()
        }
    }
    
    
    
    
    //MARK: Show Lyrick Link
    
    
    
    @Published var LyrickMusic : [Sentence] = []
    
    
    func decodeLyrick(idMusic : String) async {
        let linkRick = ZingClass.getLyrick(idMusic: idMusic)
        
        print(linkRick)
        guard let url = URL(string: linkRick) else { return }
        
        
        URLSession.shared.dataTaskPublisher(for: url) //1
            .subscribe(on: DispatchQueue.global(qos: .background)) //2
            .receive(on: DispatchQueue.main) //3
            .tryMap { (data, response) -> Data in //4
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: LyrickModel.self, decoder: JSONDecoder()) //5
            .sink { (completion) in //7
                print("completion lyrick: \(completion)")
            } receiveValue: { decoded in
                Task.detached(priority: .high) {
                    DispatchQueue.main.async {
                        self.LyrickMusic  = decoded.data!.sentences!
                    }
                }
                
            }
            .store(in: &cancellables) //8
    }
}

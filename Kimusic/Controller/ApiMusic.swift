//
//  ApiMusic.swift
//  Kimusic
//
//  Created by dat huynh on 30/07/2022.
//

import Foundation
import AVKit
import MediaPlayer
import SwiftUI

class MusicFetchApi: ObservableObject{
    
    let ZingClass = ZingCollectorLink();
    
    
    @Published var apiState: APIState = .loading
    
    @Published var MusicLink : String = ""
    
    @Published var CheckingPlay : Bool = false
    
    @Published var audioPlayer: AVAudioPlayer?
    
    @Published var angle : Double = 0
    
    @Published var showTabMusic : Bool = false

    
    @Published var MusicListUserDefault : [MusicModel] = []
    
    var myMusicList : [MusicModel] = MusicSessionManager.shared.MusicTabManger // userDefault
    
    init() {
        self.audioPlayer = nil
        MusicListUserDefault = myMusicList
    }
    
    
    func AddTemporaryData() {
        
         MusicListUserDefault.append(contentsOf: myMusicList)
    }
    
    
    @MainActor
    func executedMusic(idCode: String, titleMusic: String, MusicImage: String, MusicArtist: String) async {
        MusicSessionManager.shared.MusicTabManger.removeAll()
        MusicListUserDefault.removeAll()
        apiState = .loading
        
        MusicLink = await decoceZingMusic(idCode: idCode)!
        audioPlayer = await getDataPlayer(sound: MusicLink)
        
        audioPlayer!.isMeteringEnabled = true
        setupRemoteTransportControls()
        setupNowPlaying(audioPlayer: audioPlayer!, MusicName: titleMusic, MusicImage: LoadImage(Url: MusicImage)!, MusicArtist: MusicArtist)
        
        let MusicList: [MusicModel] = [
            MusicModel(idCode: idCode, MusicTitle: titleMusic, MusicBanner: MusicImage, ArtistName: MusicArtist, showTab: true)
        ]
        
        MusicListUserDefault =  MusicList
        MusicSessionManager.shared.MusicTabManger = MusicListUserDefault
        
        apiState = .success
    }
    
    func LoadImage(Url: String) -> UIImage? {
        let url = URL(string: Url)!
        if let data = try? Data(contentsOf: url){
            return UIImage(data: data)!
        }
        return nil
    }
    
    func decoceZingMusic(idCode: String) async ->  String? {
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
                    Task{
                        await decoceZingMusic(idCode: idCode)
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
    
    func getDataPlayer(sound: String) async -> AVAudioPlayer? {
        guard let url = URL(string: sound) else {
            print("Invalid URL")
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
    
    func play(){
        if audioPlayer!.isPlaying{audioPlayer?.pause()}
        else{audioPlayer?.play()}
        CheckingPlay = audioPlayer!.isPlaying
    }
    
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
    
    func updateTimer(){
        let currentTime = audioPlayer!.currentTime
        let total = audioPlayer!.duration
        let progress = currentTime / total
        
        withAnimation(.linear(duration: 0.1)){
            self.angle = Double(progress) * 288
        }
        CheckingPlay = audioPlayer!.isPlaying
    }
    
    func onChanged(value: DragGesture.Value){
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // 12.5 = 25 => Circle Radius...
        
        let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
        let tempAngle = radians * 180 / .pi
        
        let angle = tempAngle < 0 ? 360 + tempAngle : tempAngle
        
        // since maximum slide is 0.8
        // 0.8*36 = 288
        if angle <= 288{
            // getting time...
            let progress = angle / 288
            let time = TimeInterval(progress) * audioPlayer!.duration
            audioPlayer!.currentTime = time
            audioPlayer!.play()
            withAnimation(Animation.linear(duration: 0.1)){
                self.angle = Double(angle)
            }
        }
    }
    
    func getCurrentTime(value: TimeInterval)->String{
        return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
    }
    
    
    
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
    
}

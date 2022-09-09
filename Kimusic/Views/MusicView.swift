//
//  MusicView.swift
//  Kimusic
//
//  Created by dat huynh on 02/08/2022.
//

import SwiftUI
import Lottie


struct MusicView: View {
    @EnvironmentObject var musicController : TopLevelController
    
    var idCode : String
    var MusicTitle: String
    var ArtistName: String
    var MusicBanner: String
    
    var body: some View {
        ZStack(alignment: .center){
            Text("Loading Music, pls wait ...")
                .font(.title)
                .foregroundColor(.green)
            
        }
        .ignoresSafeArea()
        .onAppear{
            //            let music = MusicTitle
            //            MusicData = music
            
            Task{
                let musicData = MusicModel(idCode: idCode, MusicTitle: MusicTitle, MusicBanner: MusicBanner, ArtistName: ArtistName)
                
                MusicSessionManager.shared.MusicTabManger = musicData
                
                await musicController.updateMusicValue(MusicData: musicData)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
}

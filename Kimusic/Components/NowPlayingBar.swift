//
//  NowPlayingBar.swift
//  Kimusic
//
//  Created by dat huynh on 01/09/2022.
//

import SwiftUI

struct NowPlayingBar<Content: View>: View {
    var content: Content
    
    @ViewBuilder var body: some View {
        ZStack(alignment: .bottom) {
            content // Now playing bar
        }
    }
}


struct NowPlayer : View {
    
    
    @Binding var lastMusic : MusicModel
    @State private var showMediaPlayer = false
    
    var body : some View {
        ZStack {
            Rectangle().foregroundColor(Color.white.opacity(0.0)).frame(width: UIScreen.main.bounds.size.width, height: 65)
            
            
            HStack {
                Button(action: {
                    self.showMediaPlayer.toggle()
                }) {
                    HStack {
                        
                        AsyncImage(url: URL(string: lastMusic.MusicBanner)) { image in
                            image.resizable().frame(width: 45, height: 45).shadow(radius: 6, x: 0, y: 3).padding(.leading)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(lastMusic.MusicTitle).padding(.leading, 10)
                        Spacer()
                    }
                }.buttonStyle(PlainButtonStyle()).fullScreenCover(isPresented: $showMediaPlayer) {
                    LastMusicView(lastMusic: $lastMusic)
                }
                
                
                Button(action: {}) {
                    Image(systemName: "play.fill").font(.title3)
                }.buttonStyle(PlainButtonStyle()).padding(.horizontal)
                Button(action: {}) {
                    Image(systemName: "forward.fill").font(.title3)
                }.buttonStyle(PlainButtonStyle()).padding(.trailing, 30)
            }
        }
    }
}

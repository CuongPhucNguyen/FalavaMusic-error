//
//  MainScreen.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import SwiftUI
import Lottie

struct MainScreen: View {
    @State var lastMusic: MusicModel = try! JSONDecoder().decode(MusicModel.self, from: (UserDefaults.standard.object(forKey: "lastMusic") as? Data ?? JSONEncoder().encode(MusicModel(idCode: "", MusicTitle: "", MusicBanner: "", ArtistName: ""))))
    @State var viewmodle = MusicFetchApi()
    @State var myMusicList : [MusicModel] = MusicSessionManager.shared.MusicTabManger
    
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    
    @State var currentTab: Tab = .home
    
    @State var animatedIcons: [AnimatedIcon] = {
        var tabs: [AnimatedIcon] = []
        for tab in Tab.allCases{
            tabs.append(.init(tabIcon: tab, lottieView: AnimationView(name: tab.rawValue,bundle: .main)))
        }
        return tabs
    }()
    
    
    @Environment(\.colorScheme) var scheme
    
    
    var body: some View {
        NavigationView{
            
            VStack(spacing: 0){
                TabView(selection: $currentTab) {
                    HomeViews()
                        .setBG()
                        .tag(Tab.home)
                    
                    PodCastScreen()
                        .applyBG()
                        .tag(Tab.podCast)
                    
                    SearchScreen()
                        .applyBG()
                        .tag(Tab.search)
                    
                    AlbumScreen()
                        .applyBG()
                        .tag(Tab.album)
                    
                }
                
                
                    
                    //ForEach(viewmodle.MusicListUserDefault, id: \.self.id) { musicer in
//                NowPlayingBar(content: NowPlayer(Music: $viewmodle))
//                                .tag(Tab.home)
//                                .tabItem {
//                                Label("Listen Now", systemImage: "play.circle.fill")}
                NowPlayer(lastMusic: $lastMusic)
                    .onAppear{
                        lastMusic = try! JSONDecoder().decode(MusicModel.self, from: (UserDefaults.standard.object(forKey: "lastMusic") as? Data ?? JSONEncoder().encode(MusicModel(idCode: "", MusicTitle: "", MusicBanner: "", ArtistName: ""))))
                    }
//                  //  }
                   
                
                TabBar()
            }
        }
        .background(Color("BackGround").ignoresSafeArea())
        
//        .overlay(SplashScreen())
    }
    
    
    @ViewBuilder
    func TabBar()->some View{
        HStack(spacing: 0){
            ForEach(animatedIcons){icon in
                // MARK: Primary is Not Working On Xcode 14 Beta
                let tabColor: SwiftUI.Color = currentTab == icon.tabIcon ? (scheme == .dark ? .white : .black) : .gray.opacity(0.6)
                
                ResizableLottieView(lottieView: icon.lottieView,color: tabColor)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // MARK: Updating Current Tab & Playing Animation
                        currentTab = icon.tabIcon
                        icon.lottieView.play { _ in
                            // TODO
                        }
                    }
            }
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        .background {
            (scheme == .dark ? Color.black : Color.white)
                .ignoresSafeArea()
        }
    }
    
    
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
            .environmentObject(SongListViewModel())
    }
}


extension View{
    @ViewBuilder
    func setBG()->some View{
        self
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background {
                Color.primary
                    .opacity(0.05)
                    .ignoresSafeArea()
            }
    }
}

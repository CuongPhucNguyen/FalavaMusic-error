//
//  MainScreen.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import SwiftUI
import Lottie
import AVKit

struct MainScreen: View {
    
    
    //MARK: - Music Current Tab
    @State var currentTab: Tab = .home
    @State var animatedIcons: [AnimatedIcon] = {
        var tabs: [AnimatedIcon] = []
        for tab in Tab.allCases{
            tabs.append(.init(tabIcon: tab, lottieView: AnimationView(name: tab.rawValue,bundle: .main)))
        }
        return tabs
    }()
    
    
    //MARK: - gestureOffSet
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    

    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @Environment(\.colorScheme) var scheme
    
    
    //MARK: - Controll MusicData
    @State private var BackMusic : MusicModel = MusicSessionManager.shared.MusicTabManger
    @EnvironmentObject var MusicController : TopLevelController
    
    
    //MARK: - Design Musci Controller
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var time : Float = 0
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    
    @State var width : CGFloat = 0
    @State var ChangeSize : CGFloat = 0
    
    
    @State var animatedValue : CGFloat = 55
    
    //    @AppStorage("MusicDataTitle") var MusicData : String?
    
    var body: some View {
        ZStack {
            GeometryReader{proxy in
                
                let frame = proxy.frame(in: .global)
                
                TabView(selection: $currentTab) {
                    
                    NavigationView {
                        HomeViews()
                            .navigationViewStyle(.stack)
                            .navigationBarHidden(true)
                    }
                    .setBG()
                    .tag(Tab.home)
                    
                    NavigationView{
                        PodCastScreen()
                    }
                    .applyBG()
                    .tag(Tab.podCast)
                    
                    NavigationView{
                        SearchScreen()
                    }
                    .applyBG()
                    .tag(Tab.search)
                    
                    NavigationView{
                        AlbumScreen()
                    }
                    .applyBG()
                    .tag(Tab.album)
                    
                }.frame(width: frame.width, height: frame.height)
            }
            .ignoresSafeArea()
            
            
            
            
            ReactTabMusicBar()
            
            
            
        }
        .overlay(SplashScreen())
    }
    
    func startAnimation(){
        // getting levels....
        var power : Float = 0
        
        for i in 0..<MusicController.audioPlayer!.numberOfChannels{
            power += MusicController.audioPlayer!.averagePower(forChannel: i)
        }
        
        // calculation to get postive number...
        
        let value = max(0, power + 55)
        // you can also use if st to find postive number....
        
        let animated = CGFloat(value) * (maxWidth / 55)
        
        withAnimation(.linear(duration: 0.01)) {
            animatedValue = animated + 55
        }
    }
    
    
    
    func onChange(){
        DispatchQueue.main.async {
            withAnimation(.easeInOut){
                self.offset = gestureOffset + lastOffset
            }
        }
    }
    
    @ViewBuilder
    func ReactTabMusicBar() -> some View {
        GeometryReader{ proxy in
            
            let height = proxy.frame(in: .global).height
            
            ZStack {
                BlurView(style: .systemThinMaterialDark)
                    .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 30))
                
                VStack{
                    TabBar()
                    
                    if self.offset == 0 {
                        Small_Bar_Music
                    } else{
                        TabViewMusic
                    }
                    
                }
                //                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .offset(y: height - 150)
            .offset(y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
            .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                withAnimation(.easeInOut) {
                    out = value.translation.height
                    onChange()
                }
            }).onEnded({ value in
                let maxHeight = height - 100
                
                if -offset > maxHeight / 2 {
                    withAnimation(.easeInOut) {
                        self.offset = -(maxHeight / 1.1)
                        self.ChangeSize = 80
                        self.width = 250
                        
                    }
                } else{
                    withAnimation(.easeInOut) {
                        self.offset = 0
                        self.width = 0
                    }
                }
                
                // Storing Last Offset..
                // So that the gesture can contiue from the last position...
                self.lastOffset = offset
                
            }))
            
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    
    @ViewBuilder
    func TabBar()-> some View {
        HStack(spacing: 0){
            ForEach(animatedIcons){ icon in
                
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
        .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 30))
        .padding(.vertical,10)
        .background {
            Color.clear
        }
    }
    
    
}

extension MainScreen {
    
    private var Small_Bar_Music : some View {
        ZStack {
            Rectangle().foregroundColor(Color.white.opacity(0.0)).frame(width: UIScreen.main.bounds.size.width, height: 65)
            
            HStack {
                HStack {
                    AsyncImage(url: URL(string: MusicController.MusicTabBar?.MusicBanner ?? BackMusic.MusicBanner)) { image in
                        image.resizable().frame(width: 45, height: 45).shadow(radius: 6, x: 0, y: 3).padding(.leading)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text(MusicController.MusicTabBar?.MusicTitle ?? BackMusic.MusicTitle).padding(.leading, 10)
                    Spacer()
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
    
    
    private var Play_Button_Bar : some View {
        VStack{
            Slider(value: Binding(get: {time}, set: { (newValue) in
                time = newValue
                // updating player...
                MusicController.updateSilder(newTime: Double(time))
            })).padding()
            
            Button(action: MusicController.play) {
                Image(systemName: MusicController.CheckingPlay ? "pause.fill" : "play.fill")
                    .foregroundColor(.black)
                    .frame(width: ChangeSize, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
            }
        }
        .padding(.bottom, 50)
    }
    
    
    private var Disco: some View {
        ZStack{
            ZStack{
                Circle()
                    .fill(Color.pink.opacity(0.1))
                
                Circle()
                    .fill(Color.pink.opacity(0.1))
                    .frame(width: animatedValue, height: animatedValue)
            }
            .frame(width: animatedValue + 85, height: animatedValue + 85)
            
            AsyncImage(url: URL(string: MusicController.MusicTabBar?.MusicBanner ?? BackMusic.MusicBanner)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
        }
    }
    
    
    private var MainMusicView : some View {
        VStack{
            Spacer()
            Disco
            
            Text(MusicController.MusicTabBar?.MusicTitle ?? BackMusic.MusicTitle)
                .font(.callout)
                .bold()
            
            Spacer()
            
            Play_Button_Bar
            
            Spacer()
        }.onReceive(timer) { (_) in
            if MusicController.CheckingPlay {
                
                MusicController.audioPlayer!.updateMeters()
                MusicController.CheckingPlay = MusicController.audioPlayer!.isPlaying
                // updating slider....
                
                time = Float(MusicController.audioPlayer!.currentTime / MusicController.audioPlayer!.duration)
                
                startAnimation()
            }
            else{
                MusicController.CheckingPlay = false
            }
        }
    }
    
    
    private var TabViewMusic : some View {
        TabView {
            MainMusicView
            
            Color.blue
        }
        .tabViewStyle(.page(indexDisplayMode: .never))  // <--- here
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
    
    func applyBG()->some View{
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                Color("BackGround")
                    .ignoresSafeArea()
            }
    }
}

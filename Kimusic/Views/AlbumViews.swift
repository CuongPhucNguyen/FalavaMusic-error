//  AlbumsView.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import SwiftUI


struct AlbumViews: View {
    
    //Back Button config
    @Environment(\.presentationMode) var presentationMode: Binding
    
    //Config design
    @State var time = Timer.publish(every: 0.1, on:.current, in: .tracking).autoconnect()
    let idCode : String
    @State var show = false
    
    //Data
    @EnvironmentObject var vmtask : TopLevelController
    
    var body: some View {
        
        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    
                    AlbumBanner.shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    
                    titleBanner
                    
                    VStack{
                        ForEach(vmtask.ListMusic) { cors in
                            NavigationLink(destination: MusicView(idCode: cors.encodeId!,MusicTitle: cors.title!, ArtistName: cors.artistsNames!, MusicBanner: cors.thumbnailM!)){
                                CardMusic(Song: cors)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Spacer()
                }
            }
            
            if self.show{
                TopView(ImageTop: vmtask.BannerAlbum, TitleTop: vmtask.TitleAlbum)
            }
        }.onAppear{
            fetchdata()
        }.refreshable {
            fetchdata()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
        
        
    }
}


extension AlbumViews{
    
    func currentUIWindow() -> CGFloat? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        
        return window?.safeAreaInsets.top
    }
    
    private func fetchdata(){
        Task{
            await vmtask.ExecutedAlbum(idCode: idCode)
        }
    }
    
    private var AlbumBanner: some View {
        GeometryReader{ g in
            AsyncImage(url: URL(string: vmtask.BannerAlbum)) { image in
                image
                    .resizable()
                    .offset(y: g.frame(in: .global).minY > 0 ? g.frame(in: .global).minY : 0)
                    .frame(height: g.frame(in: .global).midY > 0 ?
                           UIScreen.screenHeight / 2.2 + g.frame(in: .global).minY:
                            UIScreen.screenHeight / 2.2
                    ).onReceive(self.time) { (_) in
                        let y = g.frame(in: .global).minY
                        
                        if -y > (UIScreen.screenHeight / 2.2) - 50 {
                            withAnimation {
                                self.show = true
                            }
                        } else {
                            withAnimation {
                                self.show = false
                            }
                        }
                    }.overlay(alignment: .topLeading){
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "arrowshape.turn.up.backward")
                                .renderingMode(.original)
                                .foregroundColor(Color(.systemMint))
                                .font(.system(size: 30))
                            
                        }.padding(.top, 35).padding(.leading, 20)
                    }
            } placeholder: {
                ProgressView()
            }
            
            
        }.frame(height: UIScreen.screenHeight / 2.2)
        
        
        
    }
    
    
    private var titleBanner: some View{
        VStack{
            HStack{
                Text(vmtask.TitleAlbum)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }.padding(.top)
        }.padding()
    }
    
    private func CardMusic(Song: Item) -> some View{
        
        HStack(alignment: .top, spacing: 20){
            
            AsyncImage(url: URL(string: Song.thumbnail!)) { image in
                image.resizable().frame(width: 70, height: 70).padding(.leading, 20).cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 6){
                
                TextComponents(inputText: Song.title!)
                
                TextComponents(inputText: Song.artistsNames!).foregroundColor(.gray)
            }
        }
    }
    
    
    private func TopView(ImageTop: String, TitleTop: String) -> some View {
        HStack{
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top){
                    
                    AsyncImage(url: URL(string: ImageTop)) { image in
                        image.resizable().frame(width: 25, height: 30)
                            .foregroundColor(.primary)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    TextComponents(inputText: TitleTop)
                        .font(.title)
                    
                }
                
                TextComponents(inputText: TitleTop).font(.caption).foregroundColor(.gray)
            }
            
            
            Spacer(minLength: 0)
            
            HStack(alignment: .bottom){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "arrowshape.turn.up.backward")
                        .renderingMode(.original)
                        .foregroundColor(Color(.systemMint))
                        .font(.system(size: 20))
                        .padding(.vertical, 10)
                }
                
                
                Image(systemName: "play.circle")
                    .renderingMode(.original)
                    .foregroundColor(Color(.systemMint))
                    .font(.system(size: 20))
                    .padding(.vertical, 10)
            }
            
            
        }.padding(.top, currentUIWindow()! == 0 ? 15 : (currentUIWindow())! + 5)
            .padding(.horizontal)
            .padding(.bottom)
            .background(BlurBG())
    }
}

struct BlurBG: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        return view
    }
    
}



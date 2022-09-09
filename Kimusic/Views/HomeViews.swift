//
//  HomeViews.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import SwiftUI

struct HomeViews: View {
    
    
    @EnvironmentObject var viewmodle : TopLevelController
    
    
    @Namespace var animation
    @State private var currentPage = 0
    
    @State var columns : [GridItem] = [
        GridItem(.flexible(), spacing: 12, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil)
    ]
    
    let rows = [
        GridItem(.fixed(50), spacing: 12, alignment: nil),
        GridItem(.fixed(50),spacing: 12, alignment: nil)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            PagerView(pageCount: viewmodle.Banner.count, currentIndex: $currentPage) {
                ForEach(viewmodle.Banner, id: \.self.encodeId) { co in
                    NavigationLink(destination: AlbumViews(idCode: co.encodeId!)){
                        AsyncImage(url: URL(string: co.banner!)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .aspectRatio(4/3, contentMode: .fit)
            
            CustomSegmentedControl()
            
            CustomMusicScroll(titleView: "Nhạc mới hôm nay") {
                ForEach(viewmodle.WantToListen, id: \.self.encodeId) { cosItem in
                    SongItemDisplay(idCode: cosItem.encodeId!, thumbnalM: cosItem.thumbnailM!, Title: cosItem.title!)
                }
            }
            
            CustomMusicScroll(titleView: "Chill with you") {
                ForEach(viewmodle.Chill, id: \.self.encodeId) { cosItem in
                    SongItemDisplay(idCode: cosItem.encodeId!, thumbnalM: cosItem.thumbnailM!, Title: cosItem.title!)
                }
            }
            
            CustomMusicScroll(titleView: "Mix For You") {
                ForEach(viewmodle.MixForYou, id: \.self.encodeId) { cosItem in
                    SongItemDisplay(idCode: cosItem.encodeId!, thumbnalM: cosItem.thumbnailM!, Title: cosItem.title!)
                }
            }
            
            CustomMusicScroll(titleView: "Nhạc mới mỗi ngày") {
                ForEach(viewmodle.newDay, id: \.self.encodeId) { cosItem in
                    SongItemDisplay(idCode: cosItem.encodeId!, thumbnalM: cosItem.thumbnailM!, Title: cosItem.title!)
                }
            }
            
            CustomMusicScroll(titleView: "Vì bạn đã nghe") {
                ForEach(viewmodle.AlreadyListen, id: \.self.encodeId) { cosItem in
                    SongItemDisplay(idCode: cosItem.encodeId!, thumbnalM: cosItem.thumbnailM!, Title: cosItem.title!)
                }
            }
            
            CustomMusicScroll(titleView: "Dành cho Fan") {
                ForEach(viewmodle.ForFan, id: \.self.encodeId) { cosItem in
                    SongItemDisplay(idCode: cosItem.encodeId!, thumbnalM: cosItem.thumbnailM!, Title: cosItem.title!)
                }
            }
            
        }.onAppear{
            Task{
                await viewmodle.executedZing()
            }
        }
        .padding(.bottom, 100)   
        
    }
    
    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomSegmentedControl()->some View {
        HStack(spacing: 0){
            ForEach([MusicType.Song, MusicType.Album],id: \.rawValue) {tab in
                Text(tab.rawValue.capitalized)
                    .fontWeight(.semibold)
                    .foregroundColor(viewmodle.MusicPage == tab ? .black : .white)
                    .opacity(viewmodle.MusicPage == tab ? 1 : 0.7)
                    .padding(.vertical,12)
                    .frame(maxWidth: .infinity)
                    .background{
                        // MARK: With Matched Geometry Effect
                        if viewmodle.MusicPage == tab {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [
                                        Color("Gradient1"),
                                        Color("Gradient2"),
                                        Color("Gradient3"),
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation{viewmodle.MusicPage = tab}
                    }
            }
            
        }
        .frame(width: UIScreen.screenWidth, height: 300, alignment: .top)
        .overlay {
            if viewmodle.MusicPage == .Song {
                SongMusic
                    .padding(.top, 50)
                
            } else {
                AlbumMusic
                    .padding(.top, 50)
            }
        }
        .padding(5)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.black)
        }
    }
    
    
    
    
}

struct HomeViews_Previews: PreviewProvider {
    static var previews: some View {
        HomeViews()
    }
}

extension HomeViews {
    
    
    
    private func SongItemDisplay(idCode: String, thumbnalM: String, Title: String) -> some View {
        NavigationLink(destination: AlbumViews(idCode: idCode)) {
            LazyVStack{
                AsyncImage(url: URL(string: thumbnalM)) { image in
                    image.resizable().cornerRadius(10).scaledToFill().clipped().frame(width: 200, height: 200, alignment: .leading)
                } placeholder: {
                    ProgressView()
                }
                
                TextComponents(inputText: Title)
            }
        }.buttonStyle(PlainButtonStyle())
    }
    
    private var SongMusic: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewmodle.SongNews, id: \.self.encodeId) { cosItem in
                    SongItemDisplay(idCode: cosItem.encodeId!, thumbnalM: cosItem.thumbnailM!, Title: cosItem.title!)
                }
                
            }
        }
    }
    
    
    private var AlbumMusic: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewmodle.AlbumNews, id: \.self.encodeId) { co in
                    SongItemDisplay(idCode: co.encodeId!, thumbnalM: co.thumbnailM!, Title: co.title!)
                }
                
            }
        }
    }
    
}

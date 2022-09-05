//
//  HomeViews.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import SwiftUI

struct HomeViews: View {
    
    
    @StateObject var viewmodle = SongListViewModel()
    
    
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
        CustomRefreshView(lottieFileName: "99387-loading", content: {
            VStack(spacing: 15){
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
                
//                MusicGridSong
                
                CustomSegmentedControl()
                

                
                MusicScroll(Title: "Nhạc mới hôm nay", DataLeap: viewmodle.WantToListen)
                MusicScroll(Title: "Chill with you", DataLeap: viewmodle.Chill)
                MusicScroll(Title: "Mix For You", DataLeap: viewmodle.MixForYou)
                
                MusicScroll2(Title: "Nhạc mới mỗi ngày", DataLeap: viewmodle.newDay)
                MusicScroll2(Title: "Vì bạn đã nghe", DataLeap: viewmodle.AlreadyListen)
                MusicScroll2(Title: "Dành cho Fan", DataLeap: viewmodle.ForFan)
                
                
                
            }.onAppear{
                Task{
                    await viewmodle.executedZing()
                }
            }
            .padding()
            .padding(.bottom,100)
            .navigationBarHidden(true)
                
            
        }, onRefresh: {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
        })
    }

    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomSegmentedControl()->some View {
        HStack(spacing: 0){
            ForEach([MusicType.Song, MusicType.Album],id: \.rawValue){tab in
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
            if viewmodle.MusicPage == .Song{
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

    
    private var SongMusic: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewmodle.SongNews, id: \.self.encodeId) { co in
                    NavigationLink(destination: AlbumViews(idCode: co.encodeId!)){
                        LazyVStack{
                            
                            AsyncImage(url: URL(string: co.thumbnailM!)) { image in
                                image.resizable().cornerRadius(10).scaledToFill().clipped().frame(width: 200, height: 200, alignment: .leading)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            TextComponents(inputText: co.title!)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                }
                
            }
        }
    }
    

    private var AlbumMusic: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewmodle.AlbumNews, id: \.self.encodeId) { co in
                    NavigationLink(destination: AlbumViews(idCode: co.encodeId!)){
                        LazyVStack{
                            
                            AsyncImage(url: URL(string: co.thumbnailM!)) { image in
                                image.resizable().cornerRadius(10).scaledToFill().clipped().frame(width: 200, height: 200, alignment: .leading)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            TextComponents(inputText: co.title!)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                }
                
            }
        }
    }
}


extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

//
//  MusicScroll2.swift
//  Kimusic
//
//  Created by dat huynh on 01/08/2022.
//

import SwiftUI

struct MusicScroll2: View {
    
    let Title : String
    let DataLeap: [ItemItem2]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(Title)
                .font(.title3)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(DataLeap, id: \.self.encodeId) { co in
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
}

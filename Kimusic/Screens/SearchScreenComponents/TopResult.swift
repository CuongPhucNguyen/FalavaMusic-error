//
//  File.swift
//  Kimusic
//
//  Created by Cuong Nguyen Phuc on 12/09/2022.
//

import Foundation
import SwiftUI


struct TopRow : View{
    var topResult: SearchResultsModel
    var body : some View{
        ZStack{
            RoundedRectangle(cornerSize: CGSize.init(width: 5, height: 5))
                .foregroundColor(Color.init(red: 10, green: 10, blue: 10, opacity: 10))
            HStack{
                AsyncImage(url: URL(string: (topResult.data!.top!.encodedID != nil) ? topResult.data!.top!.title! : ((topResult.data!.top!.id != nil) ? topResult.data!.top!.name! : ""))) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                                }
                    placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                VStack{
                    Text(((topResult.data != nil) ? (topResult.data!.top!.encodedID != nil) ? topResult.data!.top!.title! : ((topResult.data!.top!.id != nil) ? topResult.data!.top!.name! : "") : ""))
                        .foregroundColor(.white)
                    Text(((topResult.data != nil) ? (topResult.data!.top!.encodedID != nil) ? "Song" : ((topResult.data!.top!.id != nil) ? "Artist" : "") : ""))
                        .foregroundColor(.gray)
                }
                
            }
        }
    }
    init(topResult: SearchResultsModel){
        self.topResult = topResult
    }
}

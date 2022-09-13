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
                .foregroundColor(Color.init(red: 10, green: 10, blue: 10, opacity: 100))
                .frame(width: UIScreen.main.bounds.width - 10, height: 20)
            HStack{
                AsyncImage(url: URL(string:topResult.data?.top?.title ?? topResult.data?.top?.name ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                                }
                    placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                Spacer()
                VStack{
                    Text(topResult.data?.top?.title ?? topResult.data?.top?.name ?? "")
                        .foregroundColor(.white)
                    Text((topResult.data?.top?.title != nil ? "Song" : (topResult.data?.top?.name != nil ? "Artist" : "")))
                        .foregroundColor(.gray)
                }
                
            }
            .frame(width: UIScreen.main.bounds.width - 10, height: 60)
        }
    }
    init(topResult: SearchResultsModel){
        self.topResult = topResult
    }
}



struct preview : PreviewProvider {
    static var previews: some View{
        TopRow(topResult: SearchResultsModel.init())
    }
}

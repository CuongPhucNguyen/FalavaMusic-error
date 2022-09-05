//
//  SuggestedRow.swift
//  Kimusic
//
//  Created by Cuong Nguyen Phuc on 05/09/2022.
//

import Foundation
import SwiftUI



struct SuggestedRow : View{
    var name: String
    var imageURL: String
    var body: some View{
        ZStack{
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 5, height: 15, alignment: .center)
            HStack{
                AsyncImage(url: URL(string: imageURL))
                    .frame(width: 10, height: 10)
                Spacer()
                Text(name)
            }
            .frame(width: UIScreen.main.bounds.width - 5, height: 15, alignment: .center)
        }
    }
    init(name: String, imageURL: String){
        self.name = name
        self.imageURL = imageURL
    }
}

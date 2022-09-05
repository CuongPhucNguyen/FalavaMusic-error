//
//  AlbumScreen.swift
//  Kimusic
//
//  Created by dat huynh on 30/07/2022.
//

import SwiftUI

struct AlbumScreen: View {
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Album Screen").navigationBarHidden(true)
            }
        }
    }
}

struct AlbumScreen_Previews: PreviewProvider {
    static var previews: some View {
        AlbumScreen()
    }
}

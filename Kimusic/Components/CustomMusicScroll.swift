//
//  CustomMusicScroll.swift
//  Kimusic
//
//  Created by dat huynh on 06/09/2022.
//

import SwiftUI

struct CustomMusicScroll<Content:View> : View {
    
    let Title : String
    let content : Content
    
    init(titleView: String, @ViewBuilder content: () -> Content){
        self.Title = titleView
        self.content = content()
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text(Title)
                .font(.title3)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    content
                }
            }
        }
    }
}


struct BlurView: UIViewRepresentable {

    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView{
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

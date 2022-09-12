//
//  ScrollSearch.swift
//  Kimusic
//
//  Created by Cuong Nguyen Phuc on 12/09/2022.
//

import Foundation
import SwiftUI


struct ScrollSearch : View {
    @Binding var keywordSuggestions: [Keyword]
    @Binding var suggestedObjects: [Suggestion]
    @Binding var hidden: Bool
    var body: some View{
        ScrollView{
            VStack{
                
                    
                ForEach(keywordSuggestions, id: \.self){ suggestedKeyword in
                    Text(suggestedKeyword.keyword!)
                        .foregroundColor(.white)

                }
                ForEach(suggestedObjects, id: \.self){ suggestion in
                    if (suggestion.title != nil){
                        SuggestedRow.init(name: suggestion.title ?? "", imageURL: suggestion.thumb ?? "", duration: suggestion.duration ?? 0)
                    }
                }
                Spacer()
            }
            .opacity(hidden ? 0 : 1)
        }
    }
    init(keyword: Binding<[Keyword]>, suggestion: Binding<[Suggestion]>, hidden: Binding<Bool>){
        self._suggestedObjects = suggestion
        self._keywordSuggestions = keyword
        self._hidden = hidden
    }
}

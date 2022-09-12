//
//  SearchScreen.swift
//  Kimusic
//
//  Created by dat huynh on 30/07/2022.
//

import SwiftUI

struct SearchScreen: View {
    
    @State var searchResults = SearchGetter.init()
    @State var keyword: String = ""
    @State var url = "https://ac.zingmp3.vn/v1/web/ac-suggestions?num=10&query="
    @State var search = ""
    @State var keywordSuggestions: [Keyword] = []
    @State var suggestedObjects: [Suggestion] = []
    @State var bgDisplay = false
    @State var results = SearchResultsModel.init()
    @State var hidden = false

    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 1.3/100)
                ZStack{
                    RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.main.bounds.width - 15, height: 50)
                    TextField("Enter your searching keyword", text: $keyword)
                        .onChange(of: keyword, perform: { value in
                            Task{
                                hidden = false
                                search = ""
                                search.append(url)
                                search.append(SearchGetter.inputFormatter(keywords: keyword))
                                self.keywordSuggestions.removeAll()
                                self.suggestedObjects.removeAll()
                                self.keywordSuggestions = await  searchResults.keyword(JsonUrl:search)
                                self.suggestedObjects = await  searchResults.suggestion(JsonUrl:search)

                            }
                        })
                        .onSubmit{
                            Task{
                                hidden  = true
                                await searchResults.searchResults(searchId:SearchGetter.inputFormatter(keywords: keyword))
                                await results = searchResults.getTopResult(keywordInput: keyword)
                                print(results.data!.top!)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                }
                ScrollSearch(keyword: $keywordSuggestions, suggestion: $suggestedObjects, hidden: $hidden)
                
            }
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}

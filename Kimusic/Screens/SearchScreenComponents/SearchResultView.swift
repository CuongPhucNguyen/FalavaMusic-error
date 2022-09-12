//
//  SearchResultView.swift
//  Kimusic
//
//  Created by Cuong Nguyen Phuc on 12/09/2022.
//

import Foundation
import SwiftUI

struct SearchResultView : View {
    var results: SearchResultsModel
    var body : some View{
        VStack{
            TopRow(topResult: results)
        }
    }
    init(results: SearchResultsModel){
        self.results = results
    }
}

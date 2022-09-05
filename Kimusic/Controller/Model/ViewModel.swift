//
//  ViewModel.swift
//  Kimusic
//
//  Created by dat huynh on 01/08/2022.
//
import SwiftUI

class MusicPlayerViewModel: ObservableObject {

    // MiniPlayer Properties...
    @Published var showPlayer = false
    
    // Gesture Offset..
    @Published var offset: CGFloat = 0
    @Published var width: CGFloat = UIScreen.main.bounds.width
    @Published var height : CGFloat = 0
    @Published var isMiniPlyer = false
}

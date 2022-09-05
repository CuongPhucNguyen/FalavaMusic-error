//
//  CustomTabBar.swift
//  Kimusic
//
//  Created by dat huynh on 29/07/2022.
//

import SwiftUI
import Lottie

// MARK: Animated Icon Model
struct AnimatedIcon: Identifiable{
    var id: String = UUID().uuidString
    var tabIcon: Tab
    var lottieView: AnimationView
}


// MARK: Enum For Tabs with Rawvalue as Asset Image
enum Tab: String,CaseIterable{
    case album = "Album"
    case home = "Home"
    case search = "Search"
    case podCast = "PodCast"
}

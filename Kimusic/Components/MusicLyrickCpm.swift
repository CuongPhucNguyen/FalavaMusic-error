//
//  MusicLyrickCpm.swift
//  Kimusic
//
//  Created by Dat Huynh Dac Tan on 10/09/2022.
//

import SwiftUI

struct MusicLyrickCpm: View {
    
    var MusicDataLyrick : [Sentence]
    
    @State private var timeTravel : Double = 0
    
    
    @State private var timeController : Int = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    @EnvironmentObject var viewmodle : TopLevelController
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { pro in
                ForEach(MusicDataLyrick, id: \.self) { ly in
                    HStack {
                        ForEach(ly.words!, id: \.self) { ts in
                            
                            Text(ts.data!)
                                .font(.system(size: 22, weight: .light, design: .serif))
                                .bold()
                                .foregroundColor(timeController == (ts.startTime! / 1000) ? Color.red : Color.black)
                            
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 1.5)
                    .id(ly.words![0].startTime! / 1000)
                }
                .onChange(of: timeController) { ts in
                    withAnimation(.spring()) {
                        pro.scrollTo(ts, anchor: .center)
                    }
                }
                
            }
        }.onReceive(timer) { _ in
            timeController = viewmodle.audioPlayer!.currentTime.seconds
        }
        
    }
}



extension TimeInterval {
    
    var seconds: Int {
        return Int(self.rounded())
    }
    
    var milliseconds: Int {
        return Int(self * 1_000)
    }
}

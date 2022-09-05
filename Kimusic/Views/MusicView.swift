//
//  MusicView.swift
//  Kimusic
//
//  Created by dat huynh on 02/08/2022.
//

import SwiftUI

struct MusicView: View {
    
    //Data
    @StateObject var vmtask = MusicFetchApi()
    //Back Button config
    @Environment(\.presentationMode) var presentationMode: Binding
    
    
    //MARK: - Design
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var time : Float = 0
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    
    @State var width : CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    
    
    
    @State var animatedValue : CGFloat = 55
    
    var idCode : String
    var MusicTitle: String
    var ArtistName: String
    var MusicBanner: String
    
    
    var body: some View {
        VStack{
            MusicHeader
            
            Spacer(minLength: 0)
            
            Disco
            Spacer(minLength: 0)
            
            PlayerButton
            
        }.onReceive(timer) { (_) in
            if vmtask.CheckingPlay {
                //Update Time For Silder
                vmtask.updateTimer()
                
                vmtask.audioPlayer!.updateMeters()
                vmtask.CheckingPlay = vmtask.audioPlayer!.isPlaying
                // updating slider....
                
                time = Float(vmtask.audioPlayer!.currentTime / vmtask.audioPlayer!.duration)
                
                startAnimation()
            }
            else{
                vmtask.CheckingPlay = false
            }
        }.onAppear{
            Task{
                if let data = try? JSONEncoder().encode(MusicModel(idCode: idCode, MusicTitle: MusicTitle, MusicBanner: MusicBanner, ArtistName: ArtistName, showTab: true)){
                    UserDefaults.standard.set(data, forKey: "lastMusic")
                }
                await vmtask.executedMusic(idCode: idCode, titleMusic: MusicTitle, MusicImage: MusicBanner, MusicArtist: ArtistName)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
    func startAnimation(){
        // getting levels....
        var power : Float = 0
        
        for i in 0..<vmtask.audioPlayer!.numberOfChannels{
            power += vmtask.audioPlayer!.averagePower(forChannel: i)
        }
        
        // calculation to get postive number...
        
        let value = max(0, power + 55)
        // you can also use if st to find postive number....
        
        let animated = CGFloat(value) * (maxWidth / 55)
        
        withAnimation(.linear(duration: 0.01)){
            animatedValue = animated + 55
        }
    }
    
}

extension MusicView {
    private var PlayerButton: some View{
        ZStack{
            ZStack{
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(Color.pink.opacity(0.06),lineWidth: 4)
                    .frame(width: width + 40, height: width + 40)
                
                Circle()
                    .trim(from: 0, to: CGFloat(vmtask.angle) / 360)
                    .stroke(.pink,lineWidth: 4)
                    .frame(width: width + 30, height: width + 30)
                
                Circle()
                    .fill(.pink)
                    .frame(width: 15, height: 15)
                // Moving View...
                    .offset(x: (width + 30) / 2)
                    .rotationEffect(.init(degrees: vmtask.angle))
                // gesture...
                    .gesture(DragGesture().onChanged(vmtask.onChanged(value:)))
            }.rotationEffect(.init(degrees: 126))
            
            Button(action: vmtask.play) {
                Image(systemName: vmtask.CheckingPlay ? "pause.fill" : "play.fill")
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
            }
        }
        .padding(.top, 50)
    }
    
    
    private var Disco: some View {
        ZStack{
            ZStack{
                Circle()
                    .fill(Color.pink.opacity(0.1))
                
                Circle()
                    .fill(Color.pink.opacity(0.1))
                    .frame(width: animatedValue, height: animatedValue)
            }
            .frame(width: animatedValue + 85, height: animatedValue + 85)
            
            AsyncImage(url: URL(string: MusicBanner)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
        }
    }
    
    private var MusicHeader : some View{
        HStack{
            VStack(alignment: .leading, spacing: 8) {
                Text(MusicTitle)
                    .fontWeight(.semibold)
                
                HStack(spacing: 10){
                    
                    Text(ArtistName)
                        .font(.caption)
                }
            }
            
            Spacer(minLength: 0)
            
            Button(action: {}) {
                
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(.red)
                    .frame(width: 45, height: 45)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                
                Image(systemName: "arrow.down")
                    .foregroundColor(.black)
                    .frame(width: 45, height: 45)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .padding(.leading,10)
        }
        .padding()
    }
    
    
    
    
    
}


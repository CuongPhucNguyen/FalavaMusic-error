//
//  TextComponents.swift
//  Kimusic
//
//  Created by dat huynh on 27/07/2022.
//

import SwiftUI

struct AnimationTextCore: View{
    @State var textValue: String
    
    var font: UIFont
    
    @State var storeSize : CGSize = .zero
    @State var offSet : CGFloat = 0
    
    var  animationSpeed : Double = 0.3
    var delay : Double = 0.5
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            Text(textValue)
                .font(Font(font))
                .offset(x: offSet)
            
        }.disabled(true)
            .onAppear{
                
                let base = textValue;
                (1...30).forEach{ _ in
                    textValue.append(" ")
                }
                
                storeSize = TextSize()
                textValue.append(base)
                let time: Double = (animationSpeed * storeSize.width)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: time)){
                        offSet = -storeSize.width
                    }
                }
            }.onReceive(Timer.publish(every: ((animationSpeed * storeSize.width)), on: .main, in: .default).autoconnect()){ _ in
                offSet = delay
                withAnimation(.linear(duration: (animationSpeed * storeSize.width))){
                    offSet = -storeSize.width
                }
                
            }
    }
    
    func TextSize() -> CGSize{
        let arr = [NSAttributedString.Key.font: font]
        let size = (textValue as NSString).size(withAttributes: arr)
        return size
    }
    
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}


struct TextComponents: View {
    @State var inputText : String
    
    var body : some View{
        if(inputText.count > 20) {
            AnimationTextCore(textValue: inputText, font: .systemFont(ofSize: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
        } else{
            Text(inputText).font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
}

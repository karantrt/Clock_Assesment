//
//  GestureClock.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 05/08/22.
//

import SwiftUI

struct GestureClock: View {
    @State private var angle: CGFloat = 0
    @State private var length : CGFloat = 40
    @State private var rotateState: Double = 0
           
           var body: some View {
               // 2.
               HStack {
                   ForEach(0..<3) { _ in
                       
                       Rectangle().frame(width: 100, height: 100)
                       // 3.
                           .rotationEffect(Angle(degrees: self.rotateState))
                       // 4.
                           .gesture(RotationGesture()
                            .onChanged { value in
                                self.rotateState = value.degrees
                            }
                           )
                   }
                   .onAppear {
                       withAnimation(Animation.linear(duration: 5)) {
                           rotateState += 360
                       }
                       
                   }
               }
           }
    
}


struct GestureClock_Previews: PreviewProvider {
    static var previews: some View {
        GestureClock()
    }
}

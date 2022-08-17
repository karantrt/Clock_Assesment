//
//  RotationGestureView.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 04/08/22.
//

import SwiftUI

struct RotationGestureView: View {
    @State var angle = Angle(degrees: 120.0)

    var rotation: some Gesture {
        RotationGesture()
            .onChanged { angle in
                self.angle = angle
            }
    }

    var body: some View {
        Rectangle()
            .frame(width: 200, height: 200, alignment: .center)
            .rotationEffect(angle)
            .gesture(rotation)
    }
}

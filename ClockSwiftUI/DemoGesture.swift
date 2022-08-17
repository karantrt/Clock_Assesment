//
//  DemoGesture.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 03/08/22.
//
import SwiftUI

struct DemoGesture: View {

    private var sArray = ["e", "s", "p", "b", "k"]
    @State var isShowPopup: Bool = false
    @State private var dragPosition = CGPoint.zero

    var body: some View {

        VStack() {
            Spacer()
            Text("global: \(self.dragPosition.x) : \(self.dragPosition.y)")

            if isShowPopup {
                HStack(spacing: 5) {
                    ForEach(0..<sArray.count) { id in
                        Text("\(self.sArray[id])").fontWeight(.bold).font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(id == 2 ? Color.red : Color.blue)
                            .cornerRadius(5)
                    }
                }.offset(x:40, y:0)
            }

            Text("A").frame(width: 60, height: 90)
                .foregroundColor(.white)
                .background(Color.purple)
                .shadow(radius: 2)
                .padding(10)
                .gesture(DragGesture(minimumDistance: 2, coordinateSpace: .global)
                    .onChanged { dragGesture in
                        self.dragPosition = dragGesture.location
                        if !self.isShowPopup {self.isShowPopup.toggle()}
                }
                .onEnded {finalValue in
                    if self.isShowPopup {self.isShowPopup.toggle()}
                })
        }
    }
}

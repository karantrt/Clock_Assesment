//
//  StateDemo.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 08/08/22.
//

import SwiftUI

struct StateDemo: View {
    @State var myDict: [String: Double] = [:]
    @State var amount: Double = 100
    @State var count = [1,2,3,4,5]
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<count.count, id: \.self) { index in
                    OneUserView(myDict: $myDict, amount: amount, tag: "user \(count[index])")
                }
            }
            HStack {
                Text("\(myDict["user 1"] ?? -1)")
                Text("\(myDict["user 2"] ?? -1)")
                Text("\(myDict["user 3"] ?? -1)")
            }
        }
        
    }
}

struct OneUserView: View {
    @Binding var myDict: [String: Double]
    @State var amount: Double
    var tag: String

    var body: some View {
        HStack(alignment: .top) {
            Button(tag, action: {
                self.myDict[self.tag] = amount
            })
        }
    }
}

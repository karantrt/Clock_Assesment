//
//  SwiftUIView.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 03/08/22.
//

import SwiftUI

struct SwiftUIView: View {
    @State var array = ["Karan", "Pavan", "Tirth"]
    @State var selectedIndex = "Karan"
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            Picker(selection: $selectedIndex) {
                ForEach(array, id: \.self) {
                    Text($0)
                }
            } label: {
                Text(selectedIndex)
            }
            Text(selectedIndex)
            Button("change data") {
                array = ["Darshit bhai", "Ratnesh bhai"]
            }
        }
        

    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

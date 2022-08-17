//
//  ListView.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 03/08/22.
//

import SwiftUI

struct ListView: View {
    @Binding var array: String
    @Binding var decodeData: Result
    @State var count = [1,2,3,4,5]
    @State var bind: String?
    @State var addingProblem = false
    @State var imageName = "square"
    @State var disableImage = true
    @State var i = 0
    @State private var selectedIndex: Set<Int> = []
    
    var body: some View {
       
            VStack {
                List(0..<decodeData.zones!.count, selection: $bind) { index in
                    HStack {
                       
                        Image(systemName: selectedIndex.contains(index) ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(Color(UIColor.systemPink)).opacity(disableImage ? 0 : 1)
                        Text(decodeData.zones![index].zoneName ?? "None")
                            .onTapGesture {
                                if selectedIndex.contains(index) {
                                    
                                    selectedIndex.remove(index)
                                }
                                else {
                                    print(decodeData.zones![index].zoneName ?? "")
                                    i = index
                                    array = decodeData.zones![index].zoneName ?? ""
                                    selectedIndex.insert(index)
                                }
                                
                            }
                        
                        
                    }
                    
                }
                Text(decodeData.zones![i].zoneName ?? "none").background(.red)
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Select") {
                        self.disableImage.toggle()
                    }
                    
                }
                
            }
            .navigationTitle("Select Time Zone")
            

    }
  
}



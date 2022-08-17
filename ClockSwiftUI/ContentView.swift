//
//  ContentView.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 01/08/22.
//

import SwiftUI

struct ContentView: View {
    @State var decodedData = Result()
    @State var selectedTimeZone = "Europe/Amsterdam"
    @State var temp = ""
    @State var count = 0
    @State var hours = 0
    @State var decodedDSelectedZoneData = GetTimeZone()
  
    let defaultRegion = "Asia/Kolkata"
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<5) { _ in
                        ClockView(hour: getHours())
                    }
                }
                .task {
                    await loadTimeZones()
                }.toolbar {
                    ToolbarItem {
                        NavigationLink(destination: ListView(array: $selectedTimeZone,decodeData: $decodedData)) {
                            Text("Select Time Zone")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Select this TimeZone") {
                            Task {
                                await loadSelectedTimeZone()
                            }
                        }.background(.green)
                    }
                }
            }
        }
    }
  
    func getHours() -> Double {
      
        if decodedDSelectedZoneData != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-ddhh-mm-ss"
            let component = Calendar.current
            
            if let formattedDate = decodedDSelectedZoneData.formatted {
                let date = dateFormatter.date(from: decodedDSelectedZoneData.formatted!)
                hours = component.component(.hour, from: date!)
                print(hours)
            print(date)
            }
            
        }
        return Double(hours)
    }
    
    func loadSelectedTimeZone() async {

        print(selectedTimeZone)
        do {
            
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.timezonedb.com/v2/get-time-zone?key=GGXK7ECJN647&format=json&by=zone&zone=\(selectedTimeZone)")!)
            decodedDSelectedZoneData = try JSONDecoder().decode(GetTimeZone.self, from: data)
            print(decodedDSelectedZoneData)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
        
       
    
    func loadTimeZones() async {
        
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "http://api.timezonedb.com/v2.1/list-time-zone?key=GGXK7ECJN647&format=json")!)
            let decodedData = try JSONDecoder().decode(Result.self, from: data)
            self.decodedData.zones = decodedData.zones
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func convertTimeZone() {
        
    }
}


struct Hand: Shape {
    var offset: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(origin: CGPoint(x: rect.origin.x, y: rect.origin.y + offset), size: CGSize(width: rect.width, height: rect.height/2 - offset)), cornerSize: CGSize(width: 10, height: 10))
        return path
    }
}
struct Numbers: View {
    var number: Int
    var body: some View {
        VStack {
            Text("\(number)").foregroundColor(.white) .rotationEffect(-(.radians(Double.pi * 2 / 12 * Double(number))))
            Spacer()
        }
        .padding()
        .rotationEffect(.radians(Double.pi * 2 / 12 * Double(number)))
      
    }
}

struct Tick: Shape {
    var isScaled: Bool
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x:rect.midX, y: rect.minY + 5 + (isScaled ? 5 : 0)))
        return path
    }
}

struct Arc: Shape {
    var startAngle: Angle = .radians(0)
    var endAngle: Angle = .radians(Double.pi * 2)
    var clockwise: Bool = true
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width/2 , rect.height/2)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return path
    }
}

struct ClockView: View{
    @State var hour : Double = 0.0
    @State var rotationMinute = 0.0
    @State var rotationHours = 0.0
    @State var durationMinute = 0.0
    @State var rotationValue = 360.0
    var body: some View {
        ZStack {
            Arc()
            
            ForEach(0..<60) { position in
                Tick(isScaled: position % 5 == 0).stroke(.white,lineWidth: 2).rotationEffect(.radians(Double.pi * 2 / 60 * Double(position)))
                
            }
            ForEach(1..<13) { hours in
                Numbers(number: hours)
            }
            
                            Circle().fill(.white).frame(width: 10, height: 10, alignment: .center)
            // hour
            Hand(offset: 10).fill(.green).frame(width: 4).gesture (
                DragGesture().onChanged { gesture in
                    //                                                        offSet = gesture.translation
                }
            ).rotationEffect(.degrees(hour)) .onAppear {
                withAnimation(Animation.linear(duration: 216000).repeatForever(autoreverses: false)) {
                    hour += rotationValue
                }
            }
            // minute
            Hand(offset: 5).fill(.red).frame(width: 3)
                .rotationEffect(.degrees(rotationMinute)) .onAppear {
                    withAnimation(Animation.linear(duration: 3600).repeatForever(autoreverses: false)) {
                        rotationMinute += rotationValue
                    }
                }
            // second
            Hand(offset: 2).fill(.blue).frame(width: 2)
                .rotationEffect(.degrees(rotationHours))
                .onAppear {
                withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                    rotationHours += rotationValue
                }
            }
            
            
        }.frame(width: 200, height: 200)
//            .onAppear {
//            print("Hours\(hours)")
//            }
            .onDisappear {
                rotationValue = 0.0
            }
            .onAppear {
        
                let today = Date()
                // 2. Pick the date components
//                hours   = Double(Calendar.current.component(.hour, from: today))
                let minute = Double(Calendar.current.component(.minute, from: today))
                let seconds = (Calendar.current.component(.second, from: today))
                print( hour,"YO")
                if hour > 12 {
                    switch hour {
                    case 13:
                        hour = 1
                    case 14:
                        hour = 2
                    case 15:
                        hour = 3
                    case 16:
                        hour = 4
                    case 17:
                        hour = 5
                    case 18:
                        hour = 6
                    case 19:
                        hour = 7
                    case 20:
                        hour = 8
                    case 21:
                        hour = 9
                    case 22:
                        hour = 10
                    case 23:
                        hour = 11
                    default :
                        hour = 12

                    }
                }
                print("\(hour) \(rotationMinute)")
                hour = hour * 30 + 2
//                rotationMinute = rotationMinute *

                print("After \(hour)")

            }
//
    }
}


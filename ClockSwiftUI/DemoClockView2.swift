//
//  DemoClockView2.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 10/08/22.
//

import SwiftUI

import SwiftUI

struct DemoClockView2: View {
    @State var isDark = false
    @State var clockCount = 5
    @State var decodedData = Result()
    @State var selectedTimeZone = "Europe/Amsterdam"
    @State var timeZonesArray = [GetTimeZone]()
    @State var decodedDSelectedZoneData = GetTimeZone()
    @State var convertedTimeZone = ConvertedTimeZone()
    @State var currentTime = Time(min: 0, sec: 0, hour: 0)
    @State var cur_time = [Time]()
    @State var rotated = false
    @State var dataReceived = false
    @State var i = 0
    var body: some View {
        NavigationView {
            ScrollView (.horizontal){
                HStack(spacing:20) {
                    ForEach(timeZonesArray, id: \.self) { $index in
                        if !rotated {
                            VStack {
                                Home(currentTime: $currentTime,formatted: $index.formatted!, interval: $index.timestamp!, abbre: $index.abbreviation, index: $index, rotated: $rotated)
                                Text(timeZonesArray[index].zoneName!)
                                Spacer()
                            }
                        }
                        else {
                            VStack {
                                if dataReceived {
                                    Home(currentTime: $cur_time[index],formatted: timeZonesArray[index].formatted!, interval: timeZonesArray[index].timestamp!, abbre: timeZonesArray[index].abbreviation!, index: index, rotated: $rotated)
                                    
                                    Text(timeZonesArray[index].zoneName!)
                                    Spacer()
                                }
                                else {
                                    Home(currentTime: $currentTime,formatted: timeZonesArray[index].formatted!, interval: timeZonesArray[index].timestamp!, abbre: timeZonesArray[index].abbreviation!, index: index, rotated: $rotated)
                                    Text(timeZonesArray[index].zoneName!)
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                   
                }
                .frame(maxWidth: .infinity)
                .onChange(of: rotated, perform: {
                  value in
                    print("Minute : ", UserDefaults.standard.integer(forKey: "minute"))
                    print("Hour: ", UserDefaults.standard.integer(forKey: "hour"))
                    print("rotation", value)
                    
                    
                })
                .task {
                    await loadTimeZones()
                }
                .toolbar {
                    ToolbarItem {
                        NavigationLink(destination: ListView(array: $selectedTimeZone,decodeData: $decodedData)) {
                            Text("Select Time Zone")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Select this TimeZone") {
                            Task {
                                await loadSelectedTimeZone()
                                timeZonesArray.append(decodedDSelectedZoneData)
//                                if timeZonesArray.count > 1 {
//                                    await convertTimeZoneData()
//                                }
                            }
                        }.background(.green)
                    }
                }
                Spacer()
                VStack {
                    Button("Convert time zone") {
                        Task {
                            await convertTimeZoneData()
                        }
                    }.opacity(timeZonesArray.count > 1 ? 1:0)
                }
            }
        }
    }
    
    func convertTimeZoneData() async {
        print ("Inside Convert TimeZone")
        
        let minute = UserDefaults.standard.integer(forKey: "minute")
        print("miute from func", minute)
        let hour = UserDefaults.standard.integer(forKey: "hour")
        print("hour from func", hour)
        let second = UserDefaults.standard.integer(forKey: "second")
        print("second from func", second)
      
        print("curr ", timeZonesArray.count)
        cur_time.append(Time(min: minute, sec: second, hour: hour))
        i = 1
          
        while i < timeZonesArray.count  {
         
            do {
                print("current")
//                let date = Calendar.current.date(bySettingHour: hour , minute: minute, second: second, of: Date.now)!
//                print("Date : ", date)
//                let timestamp = date.timeIntervalSince1970
                let (data, _) = try await URLSession.shared.data(from: URL(string: "http://api.timezonedb.com/v2.1/convert-time-zone?key=GGXK7ECJN647&format=json&from=\(timeZonesArray[0].zoneName!)&to=\(timeZonesArray[i].zoneName!)")!)
                
                convertedTimeZone = try JSONDecoder().decode(ConvertedTimeZone.self, from: data)
                
                let epoch = Double(convertedTimeZone.toTimestamp!) + Double(minute * 60) + Double(hour * 60 * 60)
                let convertedDate = Date(timeIntervalSince1970: epoch)
                print("converted Date", convertedDate)
                let calendar = Calendar.current
                let convertedHour = calendar.component(.hour, from: convertedDate)
                let convertedMinute = calendar.component(.minute, from: convertedDate)
                let convertedSecond = calendar.component(.second, from: convertedDate)
                print("Converted Hour\(convertedHour) Converted Minute \(convertedMinute) Converted Second \(convertedSecond)")
                cur_time.append(Time(min: convertedMinute, sec: convertedSecond, hour: convertedHour))
//                print("timestamp",timestamp)
                print("converted Data", convertedTimeZone)
                i += 1
            }
            catch {
                print(error.localizedDescription)
            }
            dataReceived = true
            
        }
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
            print(decodedData.zones![0].zoneName!)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    func countClock () {
        clockCount += 1
    }
}

struct Home: View {
    var width = UIScreen.main.bounds.width
    
    @Binding var currentTime: Time
    @State var hour = 0
    @State var min = 0
    @State var second = 0
    @State var receiver = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var zones = [String]()
    @State var formatted = ""
    @State var interval: Int
    @State var abbre: String
    @State var length: CGFloat = 400.0
    @State var index: Int = 0
    @Binding var rotated: Bool
    var body: some View {
       
        VStack {
            Spacer(minLength: 10)
            ZStack{
                Circle()
                    .fill(.blue.opacity(0.2))
                
                // Seconds and Min dots
                ForEach(0..<60, id: \.self) { i in
                    Rectangle()
                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
                        .offset(y: (width - 110) / 2)
                        .rotationEffect(Angle(degrees: Double(i) * 6))
                }
                
                // Sec
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 2, height: (width - 180) / 2)
                    .offset(y: -(width - 180) / 4)
                    .rotationEffect(Angle(degrees: Double(currentTime.sec) * 6))
                    
                
                // Min
                Rectangle()
                    .fill(Color.primary)
                
                    .frame(width: 4, height: (width - 200) / 2)
                    .offset(y: -(width - 200) / 4)
                    .rotationEffect(Angle(degrees: Double(currentTime.min) * 6 ))
                    
                // Hour
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width - 240) / 2)
                    .offset(y: -(width - 240) / 4)
                    .rotationEffect(Angle(degrees: Double(currentTime.hour) * 30 + Double(currentTime.min / 2)))
                
                // Center Circle
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
            }
            .frame(width: width - 80, height: width - 80)
            
            Spacer(minLength: 0)
            
          
        }
        .highPriorityGesture(
            
            RotationGesture()
                .onChanged { value in
                    self.currentTime.min = Int(value.degrees) / 6
                    self.currentTime.hour = Int(value.degrees)/30 + self.currentTime.min/2
                }
                .onEnded{ value in
                    self.currentTime.min = Int(value.degrees) / 6
                    self.currentTime.hour = Int(value.degrees)/30 + self.currentTime.min/2

                    UserDefaults.standard.set(self.currentTime.min, forKey: "minute")
                    UserDefaults.standard.set(self.currentTime.hour, forKey: "hour")
                    UserDefaults.standard.set(self.currentTime.sec, forKey: "second")
                    rotated = true
                }
                
        )
        .onAppear {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatte = DateFormatter()
            dateFormatte.timeZone = TimeZone(abbreviation: abbre)
            dateFormatte.dateFormat = "HH:mm:ss"

            let k = dateFormatte.string(from: Date())
            print("view loaded")
            let time = k.split(separator: ":")
            hour = Int(time[0])!
            min = Int(time[1])!
            second = Int(time[2])!
            //
            
           
            self.currentTime = Time(min: min, sec: second, hour: hour)
                       
        }
    
        .onReceive(receiver) { _ in
            print("Current hour in function \(currentTime.hour) Current minute in function \(currentTime.min)")
            if !rotated {
               
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                //
                let dateFormatte = DateFormatter()
                dateFormatte.timeZone = TimeZone(abbreviation: abbre)
                dateFormatte.dateFormat = "HH:mm:ss"
                let k = dateFormatte.string(from: Date())
                
                let time = k.split(separator: ":")
                hour = Int(time[0])!
                min = Int(time[1])!
                second = Int(time[2])!
                
                withAnimation(Animation.linear(duration: 0.01)) {
                    self.currentTime = Time(min: min, sec: second, hour: hour)
                }
            }
            else {
            
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                //
                let dateFormatte = DateFormatter()
                dateFormatte.timeZone = TimeZone(abbreviation: abbre)
                dateFormatte.dateFormat = "HH:mm:ss"
                
                let k = dateFormatte.string(from: Date())
                
                let time = k.split(separator: ":")
                hour = Int(time[0])! + currentTime.hour
                min = Int(time[1])! + currentTime.min
                second = Int(time[2])!
             
                
                withAnimation(Animation.linear(duration: 0.01)) {
                    self.currentTime = Time(min: min, sec: second, hour: hour)
                }
            }
            
        }
        
    }
   
    
}
// Calculating Time
struct Time {
    var min: Int
    var sec: Int
    var hour: Int
}


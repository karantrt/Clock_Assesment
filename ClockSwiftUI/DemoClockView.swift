
import SwiftUI

struct DemoClockView: View {
    @State var isDark = false
    @State var clockCount = 5
    @State var decodedData = Result()
    @State var selectedTimeZone = "Europe/Amsterdam"
    @State var timeZonesArray = [GetTimeZone]()
    @State var decodedDSelectedZoneData = GetTimeZone()
    @State var convertedTimeZone = ConvertedTimeZone()
    @State var currentTime = Time(min: 0, sec: 0, hour: 0)
    @State var cur_time : Time
    @State var clockFaces: [Color] = [.red, .blue, .green]
    @State var rotated = false
    @State var dataReceived = false
    @State var offsets = [Int]()
    @State var i = 0
    var body: some View {
        NavigationView {
            
            ScrollView (.horizontal) {
                VStack(alignment: .leading) {
                    Button("Convert time zone") {
                        Task {
                            await convertTimeZoneData()
                        }
                    }.opacity(timeZonesArray.count > 1 ? 1:0)
                }
                HStack(alignment: .center, spacing: 100) {
                    ForEach(timeZonesArray.indices, id: \.self) { index in
                        
                        if !rotated {
                            VStack {
                                Home(currentTime: currentTime,formatted: timeZonesArray[index].formatted!, interval: timeZonesArray[index].timestamp!, abbre: timeZonesArray[index].abbreviation!, index: index, rotated: $rotated, zoneName: timeZonesArray[index].zoneName!)
                            }
                        }
                        else {
                            VStack {
                                if dataReceived {
                                    Home(currentTime: cur_time,formatted: timeZonesArray[index].formatted!, interval: timeZonesArray[index].timestamp!, abbre: timeZonesArray[index].abbreviation!, index: index, rotated: $rotated, zoneName: timeZonesArray[index].zoneName!, offsets: offsets[index])
                                }
                                else {
                                    Home(currentTime: currentTime,formatted: timeZonesArray[index].formatted!, interval: timeZonesArray[index].timestamp!, abbre: timeZonesArray[index].abbreviation!, index: index, rotated: $rotated, zoneName: timeZonesArray[index].zoneName!)
                                }
                            }
                        }
                       
                    }
                   
                }
                .frame(maxWidth: .infinity)
                .padding()
                .onChange(of: rotated, perform: {
                  value in
                    print("Minute : ", UserDefaults.standard.integer(forKey: "minute"))
                    print("Hour: ", UserDefaults.standard.integer(forKey: "hour"))
                    print("rotation", UserDefaults.standard.integer(forKey: "seconds"))
                    
                    
                })
                .task {
                    await loadTimeZones()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: ListView(array: $selectedTimeZone,decodeData: $decodedData)) {
                            Text("Select Time Zone")
                        }
                        .frame(width: 120, height: 30, alignment: .topLeading)
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(Color.blue.opacity(0.8))
                        .background(.linearGradient(Gradient(colors: [.green,.white, .orange]), startPoint: .top, endPoint: .bottom ))
                        
                    }
                  
                    ToolbarItem(placement: .navigationBarTrailing) {
                  
                        Button("Load Selected TimeZone") {
                            Task {
                                await loadSelectedTimeZone()
                                timeZonesArray.append(decodedDSelectedZoneData)
                            }
                        }
                        .frame(width: 165, height: 30, alignment: .trailing)
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(Color.blue.opacity(0.8))
                        .background(.linearGradient(Gradient(colors: [.green,.white, .orange]), startPoint: .top, endPoint: .bottom ))
                    }
                }
                
            }
            .navigationTitle("Clockis")
            .background(LinearGradient(gradient: Gradient(colors: [.green, .orange]), startPoint: .top, endPoint: .bottom).opacity(timeZonesArray.count > 0 ? 0.4 : 0))
//                opacity(timeZonesArray.count > 0 ? 0.2 : 0))
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
      
        cur_time = Time(min: minute, sec: second, hour: hour)
        offsets.append(0)
        i = 1
        let convertedTime: Double = Double(hour * 3600) + Double(minute * 60) + Double(second)
        while i < timeZonesArray.count  {

            do {
                print("current")
                let (data, _) = try await URLSession.shared.data(from: URL(string: "http://api.timezonedb.com/v2.1/convert-time-zone?key=GGXK7ECJN647&format=json&from=\(timeZonesArray[0].zoneName!)&to=\(timeZonesArray[i].zoneName!)&time=\(Date.now.timeIntervalSince1970 - convertedTime)")!)

                convertedTimeZone = try JSONDecoder().decode(ConvertedTimeZone.self, from: data)
                offsets.append(convertedTimeZone.offset!)
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
    
    @State var currentTime: Time = Time(min: 0, sec: 0, hour: 0)
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
    @State var zoneName = ""
    @State var offsets = 0
    var colors: [Color] = [.blue, .orange, .green, .mint]
    var body: some View {
       
        VStack {
           
            ZStack{
                Circle()
                    .fill(.linearGradient(Gradient(colors: [.green,.white, .orange]), startPoint: .top, endPoint: .bottom ))
                
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
                
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
            }
            .frame(width: width - 80, height: width - 80)
            Spacer(minLength: 10)
            
            Text("\(currentTime.hour) :  \(currentTime.min) : \(currentTime.sec)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                
            Text(zoneName).font(.system(size: 18, weight: .bold, design: .monospaced))
            Spacer()
            Spacer()
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
            dateFormatte.timeZone = TimeZone(identifier: abbre)
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
    
        .onReceive(receiver) { value in

            if !rotated {
               
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                //
                let dateFormatte = DateFormatter()
                dateFormatte.timeZone = TimeZone(identifier: abbre)
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
                let current_date = Date.now.addingTimeInterval(TimeInterval(offsets))
                print("Current Date :" , current_date)
                
            
                

                let calendarComponent = Calendar.current
                let h = calendarComponent.component(.hour, from: current_date)
                let m = calendarComponent.component(.minute, from: current_date)
                let s = calendarComponent.component(.second, from: current_date)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatte = DateFormatter()
                dateFormatte.timeZone = TimeZone(identifier: abbre)
                dateFormatte.dateFormat = "HH:mm:ss"
                
               
                
                
                if index == 0 {
                    hour = h
                    min = m
                    second = s
                    
                }
                else {
                    hour = h
                    min = m
                    second = s
                    
                }
                
                
                withAnimation(Animation.linear(duration: 0.01)) {
                    self.currentTime = Time(min: min, sec: second, hour: currentTime.hour)
                }
            }
            
        }
        
    }
   
    
}

struct Time {
    var min: Int
    var sec: Int
    var hour: Int
}

////
////  DateView.swift
////  ClockSwiftUI
////
////  Created by TRT-IOS-03 on 04/08/22.
////
//
//import SwiftUI
//import SwiftUI
//struct Country: Identifiable {
//    let id = UUID()
//    let name: String
//    //Since you need the identifier for the string and the clock it is best to have a variable for the identifier vs just the time string
//    let timeZoneIdentifier: String
//}
////You can use an extension to create other variables that use the primary ones
//extension Country{
//    ///Returns the TimeZone using the timeZoneIdentifier or the system timezone if not defined
//    var timeZone: TimeZone{
//        TimeZone(identifier: timeZoneIdentifier) ?? TimeZone.current
//    }
//    ///Returns a string with the current time in "HH:mm" format
//    var time: String{
//        Date().getLocalTimeZone(in: self.timeZone)
//    }
//}
//
//struct WorldClockView: View {
//    var countryList: [Country] = [
//        Country(
//            name: "New York",
//            timeZoneIdentifier: "America/New_York"),
//        Country(
//            name: "Paris",
//            timeZoneIdentifier: "Europe/Paris")
//    ]
//    var body: some View {
//        
//        NavigationView {
//            List(countryList) { countryItem in
//                HStack() {
//                    Text(countryItem.name + ": " + countryItem.time)
//                        .frame(height: 80.0)
//                    Spacer()
//                    //Your clock will need the timeZone
//                    ClockTestView(timeZone: countryItem.timeZone)
//                }.padding(5)
//            }
//            .navigationBarTitle("App")
//        }
//    }
//}
//
//struct WorldClockView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorldClockView()
//    }
//}
//
////I made some changes to yout date extension so you can account for the time zone
//extension Date {
//    ///Returns the hour, minute and second date component in the provided timeZone
//    func getComponents(timeZone: TimeZone = TimeZone.current) -> (hour: Double, minutes: Double, seconds: Double){
//        var calendar = Calendar.current
//        //Calendar that includes a custom timezone
//        calendar.timeZone = timeZone
//        
//        let hour: Double = Double(calendar.component(.hour, from: self))
//        
//        let minutes: Double = Double(calendar.component(.minute, from: self))
//        
//        let seconds: Double = Double(calendar.component(.second, from: self))
//        
//        return (hour, minutes, seconds)
//    }
//    ///Returns the angles for the hour, minute and second clock hands in the provided timeZone
//    func getHandAngles(timeZone: TimeZone = TimeZone.current) -> (hourAngle: Angle, minuteAngle: Angle, secondAngle: Angle ){
//        let components = self.getComponents(timeZone: timeZone)
//        
//        let hourAngle: Angle  = Angle (degrees: (360 / 12) * (components.hour + components.minutes / 60))
//        
//        let minuteAngle: Angle = Angle(degrees: (components.minutes * 360 / 60))
//        
//        let secondAngle: Angle = Angle (degrees: (components.seconds * 360 / 60))
//        
//        return(hourAngle,minuteAngle,secondAngle)
//    }
//    //Moved this here to make it more resusable
//    ///Returns a string with the current time in "HH:mm" format for the provided time zone
//    func getLocalTimeZone(in timeZone: TimeZone) -> String {
//        let f = DateFormatter()
//        f.timeZone = timeZone
//        f.dateFormat = "HH:mm"
//        return f.string(from: self)
//    }
//}
//
//struct Ticks{
//    static func tick(at tick: Int, scale: CGFloat) -> some View {
//        VStack {
//            Rectangle()
//                .fill(Color.primary)
//                .opacity(tick % 20 == 0 ? 1 : 0.4)
//                .frame(width: 2 * scale, height: (tick % 5 == 0 ? 15 : 7) * scale)
//            Spacer()
//        }
//        .rotationEffect(Angle.degrees(Double(tick)/(60) * 360))
//    }
//}
//struct ClockTestView: View {
//    var clockSize: CGFloat = 100
//    //Take in time zone to be used
//    var timeZone: TimeZone
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                let scale = geometry.size.height / 200
//                //Pass time zone to be used
//                TickHands(scale: scale, timeZone: timeZone)
//                ForEach(0..<60*4) { tick in
//                    Ticks.tick(at: tick, scale: scale)
//                }
//            }
//        }.frame(width: clockSize, height: clockSize)
//    }
//}
//struct TickHands: View {
//    var scale: Double
//    @State var dateTime: Date = Date()
//    //Take in timezone
//    let timeZone: TimeZone
//    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
//    //Get the angles in 1 variable using time zone
//    private var angles:(hourAngle: Angle, minuteAngle: Angle, secondAngle: Angle ) {
//        dateTime.getHandAngles(timeZone: timeZone)
//    }
//    var body: some View {
//        ZStack {
//            
//            Hand(inset: 65 * scale, angle: angles.hourAngle)
//                .stroke(style: StrokeStyle(lineWidth: 3 * scale, lineCap: .round, lineJoin: .round))
//            Hand(inset: 40 * scale, angle: angles.minuteAngle)
//                .stroke(style: StrokeStyle(lineWidth: 2.5 * scale, lineCap: .round, lineJoin: .round))
//            Hand(inset: 20 * scale, angle: angles.secondAngle)
//                .stroke(Color.orange, style: StrokeStyle(lineWidth: 1.5 * scale, lineCap: .round, lineJoin: .round))
//            Circle().fill(Color.orange).frame(width: 10 * scale)
//        }
//        .onReceive(timer) { (input) in
//            self.dateTime = input
//        }
//    }
//}

//
//  ClockSwiftUIApp.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 01/08/22.
//

import SwiftUI

@main
struct ClockSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            DemoClockView(cur_time: Time(min: 0, sec: 0, hour: 0))
            
        }
    }
}

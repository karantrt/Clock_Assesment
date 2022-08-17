//
//  TimeZoneData.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 01/08/22.
//

import Foundation



struct Result: Codable, Hashable {
   
    var status: String?
    var message: String?
    var zones: [TimeZoneData]?
   
}

struct TimeZoneData: Codable, Hashable {
   
    var countryCode: String?
    var countryName: String?
    var zoneName: String?
    var gmtOffset: Int?
    var timestamp: Int?
}


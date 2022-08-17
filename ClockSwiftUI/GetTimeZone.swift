//
//  GetTimeZone.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 03/08/22.
//

import Foundation

struct GetTimeZone: Codable {
     var status: String?
     var message: String?
     var countryCode: String?
     var countryName: String?
     var regionName:String?
     var cityName:String?
     var zoneName: String?
     var abbreviation: String?
     var gmtOffset: Int?
     var dst: String?
     var zoneStart: Int?
     var zoneEnd: Int?
     var nextAbbreviation: String?
     var timestamp: Int?
     var formatted: String?
}

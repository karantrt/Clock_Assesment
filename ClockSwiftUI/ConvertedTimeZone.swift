//
//  ConvertedTimeZone.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 08/08/22.
//

import Foundation

struct ConvertedTimeZone: Codable {
    var status: String?
    var message: String?
    var fromZoneName: String?
    var fromAbbreviation: String?
    var fromTimestamp: Int?
    var toZoneName: String?
    var toAbbreviation: String?
    var toTimestamp: Int?
    var offset: Int?
}

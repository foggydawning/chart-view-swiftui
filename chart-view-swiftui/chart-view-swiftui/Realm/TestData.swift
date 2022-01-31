//
//  TestData.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 31.01.2022.
//

import Foundation

final class TestData {
    static func getData() -> [(Date, Int)]{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let values = [
            (formatter.date(from: "2022-01-26T00:10")!, 70),
            (formatter.date(from: "2022-01-26T00:20")!, 68),
            (formatter.date(from: "2022-01-26T00:30")!, 70),
            (formatter.date(from: "2022-01-26T00:32")!, 75),
            (formatter.date(from: "2022-01-26T00:40")!, 65),
            (formatter.date(from: "2022-01-26T00:55")!, 60),
            (formatter.date(from: "2022-01-26T01:00")!, 60),
            (formatter.date(from: "2022-01-26T01:10")!, 55),
            (formatter.date(from: "2022-01-26T01:20")!, 58),
            (formatter.date(from: "2022-01-26T01:30")!, 60),
            (formatter.date(from: "2022-01-26T01:40")!, 49),
            (formatter.date(from: "2022-01-26T01:45")!, 55),
            (formatter.date(from: "2022-01-26T01:50")!, 55),
            (formatter.date(from: "2022-01-26T01:55")!, 50),
            (formatter.date(from: "2022-01-26T02:05")!, 50),
            (formatter.date(from: "2022-01-26T02:10")!, 47),
            (formatter.date(from: "2022-01-26T02:15")!, 50),
            (formatter.date(from: "2022-01-26T02:22")!, 50),
            (formatter.date(from: "2022-01-26T02:30")!, 45),
            (formatter.date(from: "2022-01-26T02:39")!, 43),
            (formatter.date(from: "2022-01-26T02:45")!, 49),
            (formatter.date(from: "2022-01-26T02:50")!, 49),
            (formatter.date(from: "2022-01-26T02:55")!, 49),
            (formatter.date(from: "2022-01-26T03:00")!, 45),
            (formatter.date(from: "2022-01-26T03:05")!, 55),
            (formatter.date(from: "2022-01-26T03:10")!, 55),
            (formatter.date(from: "2022-01-26T03:20")!, 60),
            (formatter.date(from: "2022-01-26T03:30")!, 60),
            (formatter.date(from: "2022-01-26T03:40")!, 60),
            (formatter.date(from: "2022-01-26T03:50")!, 50),
            (formatter.date(from: "2022-01-26T04:10")!, 49),
            (formatter.date(from: "2022-01-26T04:20")!, 45),
            (formatter.date(from: "2022-01-26T04:30")!, 50),
            (formatter.date(from: "2022-01-26T04:40")!, 55),
            (formatter.date(from: "2022-01-26T04:50")!, 55),
            (formatter.date(from: "2022-01-26T05:00")!, 60),
            (formatter.date(from: "2022-01-26T05:10")!, 65),
            (formatter.date(from: "2022-01-26T05:20")!, 70),
            (formatter.date(from: "2022-01-26T05:25")!, 75),
            (formatter.date(from: "2022-01-26T05:37")!, 75),
            (formatter.date(from: "2022-01-26T05:40")!, 75),
            (formatter.date(from: "2022-01-26T05:50")!, 80),
            (formatter.date(from: "2022-01-26T05:59")!, 85),
            (formatter.date(from: "2022-01-26T06:00")!, 85),
            (formatter.date(from: "2022-01-26T06:01")!, 70),
            (formatter.date(from: "2022-01-26T06:10")!, 70),
            (formatter.date(from: "2022-01-26T06:20")!, 60),
            (formatter.date(from: "2022-01-26T06:30")!, 55),
            (formatter.date(from: "2022-01-26T06:40")!, 60),
            (formatter.date(from: "2022-01-26T06:55")!, 40),
            (formatter.date(from: "2022-01-26T07:10")!, 85),
            (formatter.date(from: "2022-01-26T07:21")!, 70),
            (formatter.date(from: "2022-01-26T07:30")!, 70),
            (formatter.date(from: "2022-01-26T07:40")!, 68),
            (formatter.date(from: "2022-01-26T07:50")!, 64),
            (formatter.date(from: "2022-01-26T07:55")!, 60),
            (formatter.date(from: "2022-01-26T08:00")!, 60),
            (formatter.date(from: "2022-01-26T08:10")!, 65),
            (formatter.date(from: "2022-01-26T08:20")!, 64),
            (formatter.date(from: "2022-01-26T08:30")!, 63),
            (formatter.date(from: "2022-01-26T08:40")!, 62),
            (formatter.date(from: "2022-01-26T08:50")!, 61),
            (formatter.date(from: "2022-01-26T09:05")!, 60),
            (formatter.date(from: "2022-01-26T09:10")!, 63),
            (formatter.date(from: "2022-01-26T09:15")!, 64),
            (formatter.date(from: "2022-01-26T09:20")!, 60),
            (formatter.date(from: "2022-01-26T09:25")!, 55),
        ]
        return values
    }
}

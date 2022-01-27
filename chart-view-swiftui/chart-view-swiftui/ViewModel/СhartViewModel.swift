//
//  ChartViewModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI
import Combine
import Foundation


final class СhartViewModel: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    
    var model: СhartModel
    var valueByIntervals: [[Double]] = []
    var numberOfIntervals: Int = 0 {
        didSet {objectWillChange.send()}
    }
    
    init(){
        self.model = СhartViewModel.fetchModel()
    }
    

}

// MARK: Distribute Values By Intervals
extension СhartViewModel {
    
    func distributeValuesByIntervals(){
        sortValueList()
        setStartEndDate()
        setNumberOfIntervals()
        setEmptyArraysForValueByIntervals()
        distributeValues()
    }
    
    private func sortValueList(){
        self.model.values = self.model.values.sorted(by: {first, second in
            first.0 < second.0
        })
    }
    
    private func setStartEndDate() {
        self.model.startDate = self.model.values[0].0
        self.model.endDate = self.model.values.last!.0
    }
    
    private func setNumberOfIntervals(){
        guard let startDate = self.model.startDate else {return}
        guard let endDate = self.model.endDate else {return}
        let dateInterval = DateInterval(start: startDate, end: endDate)
        let timeInterval: TimeInterval = dateInterval.duration / 60
        let numberOfIntervals: Int = Int(ceil((timeInterval / 30)))
        self.numberOfIntervals = numberOfIntervals + 1
    }
    
    private func setEmptyArraysForValueByIntervals(){
        for _ in 0 ..< self.numberOfIntervals {
            self.valueByIntervals.append([])
        }
    }
    
    private func distributeValues(){
        guard let startDate = self.model.startDate else {return}
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let startDateString = formatter.string(from: startDate)
        let endIndex = startDateString.endIndex
        let extraSecondsInt = Int(startDateString[
            startDateString.index(endIndex, offsetBy: -2)..<endIndex
        ]) ?? 0
        let extraSecondsTI = TimeInterval(extraSecondsInt*60)
        let correctedStartDate = startDate - extraSecondsTI
        var currentIntervalNumber: Int = 0
        for value in self.model.values {
            let endOfTheInterval = Date(
                timeInterval: TimeInterval(60*30*(currentIntervalNumber+1)),
                since: correctedStartDate )
            if value.0 < endOfTheInterval {
                self.valueByIntervals[currentIntervalNumber].append(value.1)
            } else {
                self.valueByIntervals[currentIntervalNumber+1].append(value.1)
                currentIntervalNumber += 1
            }
        }
    }
}

// MARK: Test Data
extension СhartViewModel {
    private static func fetchModel() -> СhartModel{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return СhartModel(
            titleImageName: "heart.fill",
            titleText: "Пульс: сон",
            accentColor: Color("Heart"),
            subtitle: "Вот последние данные о Вашем пульсе во время сна.",
            values: [
                (formatter.date(from: "2022-01-26T00:10")!, 68),
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
                (formatter.date(from: "2022-01-26T02:05")!, 45),
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
                (formatter.date(from: "2022-01-26T04:40")!, 50),
                (formatter.date(from: "2022-01-26T04:50")!, 50),
            ]
        )
    }
}


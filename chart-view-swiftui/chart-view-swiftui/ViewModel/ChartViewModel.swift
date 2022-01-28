//
//  ChartViewModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI
import Combine
import Foundation

final class ChartViewModel: ObservableObject {
    var model: СhartModel
    var objectWillChange = ObservableObjectPublisher()
    
    var colomnsForRendering: [(CGFloat, CGFloat)] = [] {
        didSet {objectWillChange.send()}
    }
    
    init(){
        model = ChartViewModel.fetchModel()
    }
}

extension ChartViewModel {
    private func setColWidthAndSizeCoefficient(
        width: CGFloat,
        height: CGFloat) {
            model.colWidth = getColWidth(
                chartWidth: width,
                distanceBetweenColumns: model.distanceBetweenColumns)
            model.sizeCoefficient = getSizeCoefficient(
                chartHeight: height)
        }
    
    func setColomnsForRendering(width: CGFloat, height: CGFloat) {
        distributeValuesByIntervals()
        setColWidthAndSizeCoefficient(width: width, height: height)
        for interval in model.valueByIntervals {
            let max = interval.max() ?? 1
            let min = interval.min() ?? 0
            let height: CGFloat = getColHeight(
                                    min: min,
                                    max: max)
            let topSpacerHeight: CGFloat = getTopSpacerHeight(max: max)
            colomnsForRendering.append((topSpacerHeight, height))
        }
    }
}

// MARK: Distribute Values By Intervals
extension ChartViewModel {
    
    private func distributeValuesByIntervals(){
        sortValueList()
        setStartEndDate()
        setMinMaxValue()
        setNumberOfIntervals()
        setEmptyArraysForValueByIntervals()
        distributeValues()
    }
    
    private func setMinMaxValue(){
        var min: Double = Double.infinity
        var max: Double = 0
        for value in model.values {
            if min > value.1 {
                min = value.1
            }
            if max < value.1 {
                max = value.1
            }
        }
        model.minValue = min
        model.maxValue = max
        
    }
    private func sortValueList(){
        model.values = model.values.sorted(by: {first, second in
            first.0 < second.0
        })
    }
    
    private func setStartEndDate() {
        model.startDate = model.values[0].0
        model.endDate = model.values.last!.0
    }
    
    private func setNumberOfIntervals(){
        guard let startDate = model.startDate else {return}
        guard let endDate = model.endDate else {return}
        let dateInterval = DateInterval(start: startDate, end: endDate)
        let timeInterval: TimeInterval = dateInterval.duration / 60
        let numberOfIntervals: Int = Int(ceil((timeInterval / 30)))
        model.numberOfIntervals = numberOfIntervals + 1
    }
    
    private func setEmptyArraysForValueByIntervals(){
        for _ in 0 ..< model.numberOfIntervals {
            model.valueByIntervals.append([])
        }
    }
    
    private func distributeValues(){
        guard let startDate = model.startDate else {return}
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
        for value in model.values {
            let endOfTheInterval = Date(
                timeInterval: TimeInterval(60*30*(currentIntervalNumber+1)),
                since: correctedStartDate )
            if value.0 < endOfTheInterval {
                model.valueByIntervals[currentIntervalNumber].append(value.1)
            } else {
                model.valueByIntervals[currentIntervalNumber+1].append(value.1)
                currentIntervalNumber += 1
            }
        }
        if model.valueByIntervals.last?.isEmpty ?? false {
            _ = model.valueByIntervals.popLast()
            model.numberOfIntervals -= 1
        }
    }
}

// MARK: Funcs For Calculate View
extension ChartViewModel {
    func getColWidth (
        chartWidth: CGFloat,
        distanceBetweenColumns: CGFloat ) -> CGFloat {
        let numerator = CGFloat(
            chartWidth
            - 20.0
            - distanceBetweenColumns * CGFloat((model.numberOfIntervals-1))
        )
        let denominator = CGFloat(model.numberOfIntervals)
        return numerator / denominator
    }
    
    func getSizeCoefficient (
        chartHeight: CGFloat ) -> CGFloat {
            let maxValue: CGFloat = model.maxValue
            let minValue: CGFloat = model.minValue
            return chartHeight / (maxValue - minValue)
    }
    
    func getColHeight (
        min: Double,
        max: Double ) -> CGFloat{
            let defaultValue: CGFloat = model.colWidth / model.sizeCoefficient
            let teoreticalValue: CGFloat = max - min
            if max == min || teoreticalValue < defaultValue {
                return defaultValue
            } else {
                return teoreticalValue
            }
    }
    
    func getTopSpacerHeight(max: Double) -> CGFloat {
        CGFloat((model.maxValue) - max)
    }
    
}

// MARK: Test Data
extension ChartViewModel {
    private static func fetchModel() -> СhartModel{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return СhartModel(
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
            ]
        )
    }
}


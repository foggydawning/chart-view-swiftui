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
    private (set) var model = СhartModel(values: [])
    var objectWillChange = ObservableObjectPublisher()
    let minMaxValuePublisher = PassthroughSubject<((Double, CGFloat), MinMaxEnum), Never>()
//  startDate, endDate, distanceBetweenColumns, numberOfIntervals, colWidth
    let coordinateLineDataPublisher = PassthroughSubject<(Date, Date, CGFloat, Int, CGFloat), Never>()
    
    private (set) var colomnsForRendering: [(CGFloat, CGFloat)] = [] {
        didSet {objectWillChange.send()}
    }
    
    init(){
        fetchData()
    }
    
    func setColomnsForRendering(width: CGFloat, height: CGFloat) {
        distributeValuesByIntervals()
        setMinMaxValuePosition()
        setColWidthAndSizeCoefficient(width: width, height: height)
        sendDataForCoordinateLine()
        sendMinMaxValues()
        for interval in model.valueByIntervals {
            if interval.isEmpty {
                colomnsForRendering.append((.zero,.zero))
                continue
            }
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


// MARK: Data Flow
extension ChartViewModel {
    private func sendMinMaxValues() {
        let minValue = model.minValue
        let maxValue = model.maxValue
        let minPos = CGFloat(model.minValuePosition)
        let maxPos = CGFloat(model.maxValuePosition)
        let colWidthPlusSpacerWidth = model.colWidth+model.distanceBetweenColumns
        minMaxValuePublisher.send(
            ((minValue, minPos*colWidthPlusSpacerWidth), .min)
        )
        minMaxValuePublisher.send(
            ((maxValue, maxPos*colWidthPlusSpacerWidth), .max)
        )
    }
    
    private func sendDataForCoordinateLine() {
        guard let startDate = model.startDate else {return}
        guard let endDate = model.endDate else {return}
        let distanceBetweenColumns = model.distanceBetweenColumns
        let numberOfIntervals = model.numberOfIntervals
        let colWidth = model.colWidth
        coordinateLineDataPublisher
            .send(
                (startDate,
                endDate,
                distanceBetweenColumns,
                numberOfIntervals,
                colWidth)
            )
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
    
    private func setMinMaxValuePosition(){
        var curPosition: Int = 0
        var minPosDefined: Bool = false
        var maxPosDefined: Bool = false
        for interval in model.valueByIntervals {
            if interval.contains(model.minValue) && !minPosDefined{
                model.minValuePosition = curPosition
                minPosDefined.toggle()
            }
            if interval.contains(model.maxValue) && !maxPosDefined {
                model.maxValuePosition = curPosition
                maxPosDefined.toggle()
            }
            curPosition += 1
        }
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
        formatter.dateFormat = "mm"
        let extraMinutesString = formatter.string(from: startDate)
        let extraMinutesInt = Int(extraMinutesString) ?? 0
        let extraSecondsTI = TimeInterval(extraMinutesInt*60)
        let correctedStartDate = startDate - extraSecondsTI
        var currentIntervalNumber: Int = 0
        var currentValueNumber: Int = 0
        while currentValueNumber < model.values.count {
            let value = model.values[currentValueNumber]
            let endOfTheInterval = Date(
                timeInterval: TimeInterval(60*30*(currentIntervalNumber+1)),
                since: correctedStartDate )
            if value.0 < endOfTheInterval {
                model.valueByIntervals[currentIntervalNumber].append(value.1)
                currentValueNumber += 1
            } else {
                currentIntervalNumber += 1
            }
        }
        if model.valueByIntervals.last?.isEmpty == false {
            _ = model.valueByIntervals.popLast()
            model.numberOfIntervals -= 1
        }
    }
    
    private func setColWidthAndSizeCoefficient(
        width: CGFloat,
        height: CGFloat) {
            model.colWidth = getColWidth(
                chartWidth: width,
                distanceBetweenColumns: model.distanceBetweenColumns)
            model.sizeCoefficient = getSizeCoefficient(
                chartHeight: height)
        }
}


// MARK: Funcs For Calculating View
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
            let diffirence: CGFloat = maxValue - minValue
            if diffirence == 0 {
                return 1
            }
            return chartHeight / diffirence
    }
    
    func getColHeight (
        min: Double,
        max: Double ) -> CGFloat{
            let defaultValue: CGFloat = model.colWidth / model.sizeCoefficient
            let teoreticalValue: CGFloat = max - min
            if max == min || teoreticalValue < defaultValue{
                return defaultValue * model.sizeCoefficient
            } else {
                return teoreticalValue * model.sizeCoefficient
            }
    }
    
    func getTopSpacerHeight(max: Double) -> CGFloat {
        CGFloat((model.maxValue) - max) * model.sizeCoefficient
    }
    
}

// MARK: Test Data
extension ChartViewModel {
    private func fetchData(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        model.values = [
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
    }
}


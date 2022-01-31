//
//  ChartViewModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI
import Combine
import Foundation
import RealmSwift

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
        // start Block ONLY FOR A TEST
        if model.values.isEmpty {
            writeTestDataToDB()
            fetchData()
        }
        // end Block ONLY FOR A TEST
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
            let valueNumber = Double(value.1)
            if min > valueNumber {
                min = valueNumber
            }
            if max < valueNumber {
                max = valueNumber
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
        let numberHalfHours: Double = timeInterval / 30
        var numberOfIntervals: Int = Int(ceil((timeInterval / 30)))
        if let fractPartString = String(numberHalfHours).split(separator: ".").last{
            if Int(fractPartString) == .zero {
                numberOfIntervals += 1
            }
        }
        model.numberOfIntervals = numberOfIntervals
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
                model.valueByIntervals[currentIntervalNumber].append(Double(value.1))
                currentValueNumber += 1
            } else {
                currentIntervalNumber += 1
            }
        }
        if model.valueByIntervals.last?.isEmpty == true {
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

// MARK: Fetch Data
extension ChartViewModel {
    private func fetchData(){
        let realm = try! Realm()
        if let lastGroup = realm.objects(RealmGroupValuesModel.self).last {
            for value in lastGroup.values {
                model.values.append((value.date, value.value))
            }
        }
    }
}

// MARK: Test Data ONLY FOR A TEST
extension ChartViewModel {
    private func writeTestDataToDB(){
        let testValues: [(Date, Int)] = TestData.getData()
        let realm = try! Realm()
        let group = RealmGroupValuesModel()
        for value in testValues {
            let DBValue = RealmValueModel()
            DBValue.value = value.1
            DBValue.date = value.0
            group.values.append(DBValue)
        }
        realm.beginWrite()
        realm.add(group)
        try! realm.commitWrite()
    }
}

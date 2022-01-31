//
//  ChartModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI
import Foundation

struct СhartModel {
    var values: [(Date, Int)]
    var numberOfIntervals: Int = 0
    var valueByIntervals: [[Double]] = []
    
    var minValue: Double = 0
    var maxValue: Double = 1
    var maxValuePosition: Int = 0
    var minValuePosition: Int = 0
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    var distanceBetweenColumns: CGFloat = 4
    var colWidth: CGFloat = 5
    var sizeCoefficient: CGFloat  = 1
}

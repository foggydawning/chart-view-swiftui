//
//  ChartModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI
import Foundation

struct СhartModel {
    var values: [(Date, Double)]
    var numberOfIntervals: Int = 0
    var valueByIntervals: [[Double]] = []
    
    var minValue: Double = 0
    var maxValue: Double = 1
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var distanceBetweenColumns: CGFloat = 5
    var colWidth: CGFloat = 5
    var sizeCoefficient: CGFloat  = 1
}

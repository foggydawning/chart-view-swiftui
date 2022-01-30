//
//  CoordinateLineModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 30.01.2022.
//
import Foundation
import CoreGraphics

struct CoordinateLineModel {
    var startDate: Date? = nil
    var endDate: Date? = nil
    var distanceBetweenColumns: CGFloat = 4
    var numberOfIntervals: Int = 1
    var colWidth: CGFloat = 5
}

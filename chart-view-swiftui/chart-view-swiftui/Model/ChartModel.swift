//
//  ChartModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI
import Foundation

struct СhartModel {
    let titleImageName: String
    let titleText: String
    let accentColor: Color
    var subtitle: String
    var values: [(Date, Double)]
    var minValue: Double? = nil
    var maxValue: Double? = nil
    var startDate: Date? = nil
    var endDate: Date? = nil
}

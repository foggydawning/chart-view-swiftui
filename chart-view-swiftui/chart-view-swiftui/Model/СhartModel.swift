//
//  chartModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct СhartModel {
    let titleIcon: Image
    let titleText: String
    let accentColor: Color
    var subtitles: [String]
    var minValue: (Int, Double)
    var maxValue: (Int, Double)
}

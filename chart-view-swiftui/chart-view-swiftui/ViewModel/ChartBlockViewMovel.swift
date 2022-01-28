//
//  ChartBlockViewMovel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 28.01.2022.
//

import Combine

final class ChartBlockViewMovel: ObservableObject {
    var model: ChartBlockModel
    var chartViewModel: ChartViewModel
    
    init(model: ChartBlockModel, chartViewModel: ChartViewModel) {
        self.model = model
        self.chartViewModel = chartViewModel
    }
    
}

//
//  ChartBlockViewMovel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 28.01.2022.
//

import Combine

final class ChartBlockViewMovel: ObservableObject {
    private var subscribtions = Set<AnyCancellable>()
    
    private (set) var model: ChartBlockModel
    var chartViewModel: ChartViewModel
    private (set) var maxValueViewModel = MinMaxValueViewModel()
    private (set) var minValueViewModel = MinMaxValueViewModel()
    
    init(model: ChartBlockModel, chartViewModel: ChartViewModel) {
        self.model = model
        self.chartViewModel = chartViewModel
        makeSubscriptions()
    }
    
    private func makeSubscriptions(){
        chartViewModel
            .minMaxValuePublisher
            .sink(receiveValue: { value in
                if value.1 == .max {
                    self.maxValueViewModel.updateModel(
                        value: value.0.0,
                        text: value.1.rawValue,
                        widthLeftSpacer: value.0.1)
                }
            })
            .store(in: &subscribtions)
        chartViewModel
            .minMaxValuePublisher
            .sink(receiveValue: { value in
                if value.1 == .min {
                    self.minValueViewModel.updateModel(
                        value: value.0.0,
                        text: value.1.rawValue,
                        widthLeftSpacer: value.0.1)
                }
            })
            .store(in: &subscribtions)
    }
}

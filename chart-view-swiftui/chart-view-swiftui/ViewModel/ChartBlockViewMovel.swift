//
//  ChartBlockViewMovel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 28.01.2022.
//

import Combine

final class ChartBlockViewMovel: ObservableObject {
    private var subscribtions = Set<AnyCancellable>()
    
    var model: ChartBlockModel
    var chartViewModel: ChartViewModel
    var maxValueViewModel = MinMaxValueViewModel()
    var minValueViewModel = MinMaxValueViewModel()
    
    init(model: ChartBlockModel, chartViewModel: ChartViewModel) {
        self.model = model
        self.chartViewModel = chartViewModel
        makeSubscriptions()
    }
    
    func makeSubscriptions(){
        chartViewModel
            .minMaxValuePublisher
            .sink(receiveValue: { value in
                if value.1 == .max {
                    self.maxValueViewModel.updateModel(
                        value: value.0,
                        text: value.1.rawValue,
                        widthLeftSpacer: 20)
                }
            })
            .store(in: &subscribtions)
        chartViewModel
            .minMaxValuePublisher
            .sink(receiveValue: { value in
                if value.1 == .min {
                    self.minValueViewModel.updateModel(
                        value: value.0,
                        text: value.1.rawValue,
                        widthLeftSpacer: 20)
                }
            })
            .store(in: &subscribtions)
    }
}

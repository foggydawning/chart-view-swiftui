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
    private (set) var coordinateLineViewModel =  CoordinateLineViewModel()
    
    init(model: ChartBlockModel, chartViewModel: ChartViewModel) {
        self.model = model
        self.chartViewModel = chartViewModel
        makeSubscriptions()
    }
    
    private func makeSubscriptions(){
        chartViewModel
            .minMaxValuePublisher
            .sink(receiveValue: { valueText, minMaxType in
                if minMaxType == .max {
                    self.maxValueViewModel.updateModel(
                        value: valueText.0,
                        text: minMaxType.rawValue,
                        widthLeftSpacer: valueText.1)
                }
            })
            .store(in: &subscribtions)
        chartViewModel
            .minMaxValuePublisher
            .sink(receiveValue: { valueText, minMaxType in
                if minMaxType == .min {
                    self.minValueViewModel.updateModel(
                        value: valueText.0,
                        text: minMaxType.rawValue,
                        widthLeftSpacer: valueText.1)
                }
            })
            .store(in: &subscribtions)
        
        chartViewModel
            .coordinateLineDataPublisher
            .sink(receiveValue: { startDate, endDate, distanceBetweenColumns, numberOfIntervals, colWidth in
                self.coordinateLineViewModel.setNewDataToModel(
                    startDate: startDate,
                    endDate: endDate,
                    distanceBetweenColumns: distanceBetweenColumns,
                    numberOfIntervals: numberOfIntervals,
                    colWidth: colWidth
                )
            })
            .store(in: &subscribtions)
        
        
    }
}

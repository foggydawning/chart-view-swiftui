//
//  CoordinateLineViewModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 30.01.2022.
//

import Foundation
import Combine
import CoreGraphics

final class CoordinateLineViewModel: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    private (set) var model = CoordinateLineModel() {
        didSet {
            objectWillChange.send()
        }
    }
    
    func setNewDataToModel(
        startDate: Date?,
        endDate: Date?,
        distanceBetweenColumns: CGFloat,
        numberOfIntervals: Int,
        colWidth: CGFloat){
            model.startDate = startDate
            model.endDate = endDate
            model.distanceBetweenColumns = distanceBetweenColumns
            model.numberOfIntervals = numberOfIntervals
            model.colWidth = colWidth
    }
}

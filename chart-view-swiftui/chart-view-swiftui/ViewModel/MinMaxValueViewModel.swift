//
//  MinMaxValueViewModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 28.01.2022.
//

import Combine
import CoreGraphics

final class MinMaxValueViewModel: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    var model = MinMaxValueModel() {
        didSet {
            objectWillChange.send()
        }
    }
    
    func updateModel(value: Double,
                     text: String,
                     widthLeftSpacer: CGFloat) {
        model = MinMaxValueModel(
            value: value,
            text: text,
            widthLeftSpacer: widthLeftSpacer
        )
    }
    
}

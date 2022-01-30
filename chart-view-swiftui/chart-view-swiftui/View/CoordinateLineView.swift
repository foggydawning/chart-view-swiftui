//
//  CoordinateLineView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 30.01.2022.
//

import SwiftUI

struct CoordinateLineView: View {
    @ObservedObject var viewModel: CoordinateLineViewModel
    let lineWidth: CGFloat = 3
    
    var body: some View {
        HStack {
            ForEach (0 ..< viewModel.model.numberOfIntervals, id: \.self) { i in
                if i % 2 == 0 || i == viewModel.model.numberOfIntervals - 1 {
                    if i == 0 || i == viewModel.model.numberOfIntervals - 1 {
                        Rectangle().frame(width: lineWidth, height: 10)
                            .cornerRadius(30)
                    } else {
                        Circle().frame(width: lineWidth, height: lineWidth)
                    }
                } else {
                    Spacer().frame(width: lineWidth)
                }
                    
                if i != viewModel.model.numberOfIntervals - 1{
                    Spacer().frame(width: viewModel.model.distanceBetweenColumns
                                            + viewModel.model.colWidth
                                            - lineWidth)
                }
                
            }
        }.foregroundColor(Color("Light Gray"))
    }
}

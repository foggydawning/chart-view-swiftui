//
//  ChartView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        GeometryReader { internalGeometry in
            HStack(alignment: .top , spacing: 0){
                Spacer().frame(width: 10)
                ForEach(0 ..< viewModel.colomnsForRendering.count, id: \.self){ i in
                    let colomn: (CGFloat, CGFloat) = viewModel.colomnsForRendering[i]
                    let colHeight: CGFloat = colomn.1
                    let topSpacerHeight: CGFloat = colomn.0
                    VStack(spacing: 0){
                        Spacer().frame(height: topSpacerHeight)
                        Rectangle()
                            .frame(width: viewModel.model.colWidth,
                                   height: colHeight)
                            .cornerRadius(30)
                        Spacer()
                    }
                    Spacer().frame(width: viewModel.model.distanceBetweenColumns)
                }
                Spacer().frame(width: 10-viewModel.model.distanceBetweenColumns)
            }.onAppear(perform: {
                let width: CGFloat = internalGeometry.size.width
                let height: CGFloat = internalGeometry.size.height
                viewModel.setColomnsForRendering(width: width, height: height)
            })
        }
    }
}

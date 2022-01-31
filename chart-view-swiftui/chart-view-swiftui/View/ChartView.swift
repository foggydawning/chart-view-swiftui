//
//  ChartView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel
    let leadingTrailingMargin: CGFloat = 10
    
    var body: some View {
        GeometryReader { internalGeometry in
            HStack(alignment: .top , spacing: 0){
                Spacer().frame(width: leadingTrailingMargin)
                ForEach(0 ..< viewModel.colomnsForRendering.count, id: \.self){ i in
                    let colomn: (CGFloat, CGFloat) = viewModel.colomnsForRendering[i]
                    let colHeight: CGFloat = colomn.1
                    let colWidth: CGFloat = viewModel.model.colWidth
                    let topSpacerHeight: CGFloat = {
                        (colWidth == colHeight && viewModel.model.minValuePosition == i) ? colomn.0 - colHeight : colomn.0
                    }()
                    ZStack {
                        VStack(spacing: 0){
                            Spacer().frame(height: topSpacerHeight)
                            Rectangle()
                                .frame(width: colWidth,
                                       height: colHeight)
                                .cornerRadius(30)
                            Spacer()
                        }
                        if viewModel.model.maxValuePosition == i {
                            MinMaxPoint(minOrMax: .max,
                                        topSpacerHeight: topSpacerHeight,
                                        colHeight: colHeight,
                                        colWidth: colWidth)
                        } else if viewModel.model.minValuePosition == i {
                            MinMaxPoint(minOrMax: .min,
                                        topSpacerHeight: topSpacerHeight,
                                        colHeight: colHeight,
                                        colWidth: colWidth)
                        }
                    }
                    Spacer().frame(width: viewModel.model.distanceBetweenColumns)
                }
                Spacer().frame(
                    width: leadingTrailingMargin)
            }.onAppear(perform: {
                let width: CGFloat = internalGeometry.size.width
                let height: CGFloat = internalGeometry.size.height
                viewModel.setColomnsForRendering(width: width, height: height)
            })
        }
    }
    
    private struct MinMaxPoint: View {
        let minOrMax: MinMaxEnum
        let topSpacerHeight, colHeight, colWidth: CGFloat
        
        var body: some View {
            VStack(spacing: 0){
                Spacer().frame(height: minOrMax == .min
                               ? topSpacerHeight+colHeight-colWidth*0.8
                               : topSpacerHeight+colWidth*0.2)
                Circle()
                    .frame(width: colWidth*0.6,
                           height: colWidth*0.6)
                    .foregroundColor(Color("Background"))
                Spacer()
            }
        }
    }
}

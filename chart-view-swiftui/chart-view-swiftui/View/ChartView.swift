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
                ForEach(0 ..< self.viewModel.colomnsForRendering.count, id: \.self){ i in
                    let colomn: (CGFloat, CGFloat) = self.viewModel.colomnsForRendering[i]
                    VStack{
                        Spacer().frame(height: colomn.0*viewModel.model.sizeCoefficient)
                        Rectangle()
                            .frame(width: viewModel.model.colWidth, height: colomn.1*viewModel.model.sizeCoefficient)
                            .cornerRadius(30)
                        Spacer()
                    }
                    Spacer().frame(width: viewModel.model.distanceBetweenColumns)
                }
                Spacer().frame(width: 10-viewModel.model.distanceBetweenColumns)
            }.onAppear(perform: {
                let width: CGFloat = internalGeometry.size.width
                let height: CGFloat = internalGeometry.size.height
                self.viewModel.setColomnsForRendering(width: width, height: height)
            })
        }
    }
}

//
//  ChartView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct СhartView: View {
    @ObservedObject var viewModel: ChartViewModel
    let margin: CGFloat = 15
    let distanceBetweenColumns: CGFloat = 5
    
    var body: some View {
        VStack(spacing: 0){
            Title(imageName: self.viewModel.model.titleImageName,
                  text: self.viewModel.model.titleText,
                  color: self.viewModel.model.accentColor)
            Spacer()
            Subtitle(text: self.viewModel.model.subtitle)
            Spacer()
            DividingLine()
            Spacer()
            GeometryReader { geometry in
                VStack(spacing: 0){
                    HStack {
                        Spacer()
                        VStack {
                            Text("МАКС.")
                                .font(.system(size: 12, weight: .bold, design: .default))
                            Text(String(format: "%.1f", viewModel.model.maxValue?.1 ?? 100))
                                .font(.system(size: 20, weight: .semibold, design: .default))
                        }
                        
                        Spacer()
                    }
                    GeometryReader { internalGeometry in
                        let width: CGFloat = internalGeometry.size.width
                        let height: CGFloat = internalGeometry.size.height
                        let minValue: Double = self.viewModel.model.minValue?.1 ?? 0
                        let maxValue: Double = self.viewModel.model.maxValue?.1 ?? 1
                        let colWidth: CGFloat = viewModel.getColWidth(
                            chartWidth: width,
                            distanceBetweenColumns: distanceBetweenColumns)
                        let sizeCoefficient: CGFloat = viewModel.getSizeCoefficient(
                            minValue: minValue,
                            maxValue: maxValue,
                            chartHeight: height)
                        HStack(alignment: .top , spacing: 0){
                            Spacer().frame(width: 10)
                            ForEach(self.viewModel.valueByIntervals, id: \.self){ interval in
                                let max = interval.max() ?? 1
                                let min = interval.min() ?? 0
                                let height: CGFloat = viewModel.getColHeight(
                                    min: min,
                                    max: max,
                                    sizeCoefficient: sizeCoefficient,
                                    colWidth: colWidth)
                                
                                let topSpacerHeight: CGFloat = viewModel.getTopSpacerHeight(max: max)
                                
                                VStack{
                                    Spacer().frame(height: topSpacerHeight*sizeCoefficient)
                                    Rectangle()
                                        .frame(width: colWidth, height: height*sizeCoefficient)
                                        .cornerRadius(30)
                                    Spacer()
                                    
                                }
                                Spacer().frame(width: distanceBetweenColumns)
                            }
                            Spacer().frame(width: 10-distanceBetweenColumns)
                        }
                    }
                    HStack {
                        Spacer()
                        VStack {
                            Text("МИН.")
                                .font(.system(size: 12, weight: .bold, design: .default))
                            Text(String(viewModel.model.minValue?.1 ?? 0))
                                .font(.system(size: 20, weight: .semibold, design: .default))
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Color(.black)
                            .frame(height: 20)
                    }
                    Spacer().frame(height: 10)
                }.foregroundColor(viewModel.model.accentColor)
            }
        }
        .padding(margin)
        .background(Color.white)
        .cornerRadius(10)
        .padding(margin)
        .onAppear(perform: {self.viewModel.distributeValuesByIntervals()})
    }
    
    private struct Subtitle: View {
        let text: String
        var body: some View {
            HStack {
                Text(text)
                    .fontWeight(.semibold)
            }
        }
    }
    
    private struct Title: View {
        let imageName: String
        let text: String
        let color: Color
        
        var body: some View {
            HStack (spacing: 2){
                Image(systemName: imageName)
                Text(text)
                    .font(.system(size: 15, weight: .semibold, design: .default))
                Spacer()
            }.foregroundColor(color)
        }
    }
    
    private struct DividingLine: View {
        var body: some View {
            Rectangle()
                .frame(height: 0.3)
                .cornerRadius(10)
                .foregroundColor(Color.gray.opacity(0.7))
                
        }
    }
}

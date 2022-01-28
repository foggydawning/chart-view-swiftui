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
                        Text("68")
                        Spacer()
                    }
                    GeometryReader { internalGeometry in
                        let width: CGFloat = internalGeometry.size.width
                        let height: CGFloat = internalGeometry.size.height
                        let minValue: Double = self.viewModel.model.minValue ?? 0
                        let maxValue: Double = self.viewModel.model.maxValue ?? 1
                        let colWidth: CGFloat = viewModel.getColWidth(chartWidth: width)
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
                                        .foregroundColor(viewModel.model.accentColor)
                                        .frame(width: colWidth, height: height*sizeCoefficient)
                                        .cornerRadius(30)
                                    Spacer()
                                    
                                }
                                Spacer().frame(width: 5)
                            }
                            Spacer().frame(width: 5)
                        }
                    }
                    HStack {
                        Spacer()
                        Text("45")
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Color(.black)
                            .frame(height: 20)
                    }
                }
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
                .padding([.leading,.trailing], 6)
                .foregroundColor(Color.gray.opacity(0.7))
                
        }
    }
}

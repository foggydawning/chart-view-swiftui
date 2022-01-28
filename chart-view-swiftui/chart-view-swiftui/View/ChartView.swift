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
                        let colWidth: CGFloat = {
                            let numberOfIntervals = CGFloat(self.viewModel.numberOfIntervals)
                            let colWidth: CGFloat = (internalGeometry.size.width
                            - 20.0 - 5.0*(numberOfIntervals-1)) / numberOfIntervals
                            return colWidth
                        }()
                        let sizeCoefficient: CGFloat = {
                            let min: CGFloat = self.viewModel.model.minValue ?? 0
                            let max: CGFloat = self.viewModel.model.maxValue ?? 1
                            return internalGeometry.size.height / (max - min)
                        }()
                        HStack(alignment: .top , spacing: 0){
                            Spacer().frame(width: 10)
                            ForEach(self.viewModel.valueByIntervals, id: \.self){ interval in
                                
                                let height: CGFloat = {
                                    let max = interval.max() ?? 1
                                    let min = interval.min() ?? 0
                                    if max == min {
                                        return colWidth / sizeCoefficient
                                    } else {
                                        if max - min < colWidth / sizeCoefficient {
                                            return colWidth / sizeCoefficient
                                        }
                                        return max - min
                                    }
                                }()
                                
                                let topSpacerHeight: CGFloat = {
                                    let max = interval.max() ?? 1
                                    let globalMax = self.viewModel.model.maxValue ?? 1
                                    return CGFloat(globalMax - max)
                                }()
                                
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

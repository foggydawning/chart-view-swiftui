//
//  ChartBlockVIew.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 28.01.2022.
//

import SwiftUI

struct ChartBlockView: View {
    @ObservedObject var viewModel: ChartBlockViewMovel
    let margin: CGFloat = 15
    
    var body: some View {
        GeometryReader { geometry in
            let height: CGFloat = geometry.size.height
            VStack(spacing: 0){
                Title(imageName: viewModel.model.titleImageName,
                      text: viewModel.model.titleText,
                      color: viewModel.model.accentColor)
                Spacer()
                Subtitle(text: viewModel.model.subtitle)
                Spacer()
                DividingLine()
                Spacer()
                VStack(spacing: 0){
                    MinMaxValueView(viewModel: viewModel.maxValueViewModel)
                    ChartView(viewModel: viewModel.chartViewModel)
                    MinMaxValueView(viewModel: viewModel.minValueViewModel)
                    HStack {
                        Color(.black)
                            .frame(height: 20)
                    }
                    Spacer().frame(height: height*0.04)
                }.foregroundColor(viewModel.model.accentColor)
            }
            .padding(margin)
            .background(Color.white)
            .cornerRadius(10)
            .padding(margin)
        }
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

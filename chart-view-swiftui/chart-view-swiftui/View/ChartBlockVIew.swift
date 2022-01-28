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
                            Text(String(format: "%.1f", viewModel.chartViewModel.model.maxValue ?? 100))
                                .font(.system(size: 20, weight: .semibold, design: .default))
                        }
                        
                        Spacer()
                    }
                    ChartView(viewModel: viewModel.chartViewModel)
                    HStack {
                        Spacer()
                        VStack {
                            Text("МИН.")
                                .font(.system(size: 12, weight: .bold, design: .default))
                            Text(String(viewModel.chartViewModel.model.minValue ?? 0))
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

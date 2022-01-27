//
//  ChartView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct СhartView: View {
    @ObservedObject var viewModel = СhartViewModel()
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
                            (internalGeometry.size.width
                            - 20.0
                            - 5.0*(CGFloat(self.viewModel.numberOfIntervals-1)))
                            / CGFloat(self.viewModel.numberOfIntervals)
                        }()
                        HStack(spacing: 0){
                            Spacer().frame(width: 10)
                            ForEach(self.viewModel.valueByIntervals, id: \.self){_ in
                                Rectangle()
                                    .foregroundColor(viewModel.model.accentColor)
                                    .frame(width: colWidth)
                                    .cornerRadius(30)
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
                    .font(.system(size: 15, weight: .bold, design: .default))
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

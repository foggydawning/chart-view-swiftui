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
    let leadingTrailingMargin: CGFloat = 10
    
    var body: some View {
        let numberOfIntervals: Int = viewModel.model.numberOfIntervals
        let colWidth: CGFloat = viewModel.model.colWidth
        let distanceBetweenColumns: CGFloat = viewModel.model.distanceBetweenColumns
        let lastIndex: Int = numberOfIntervals - 1
        VStack (spacing: 0){
            HStack (spacing: 0) {
                Spacer().frame(
                    width: leadingTrailingMargin + colWidth/2 - lineWidth/2)
                ForEach (0 ..< numberOfIntervals, id: \.self) { i in
                    if i % 2 == 0 || i == lastIndex {
                        if i == 0 || i == lastIndex {
                            Rectangle().frame(width: lineWidth, height: 10)
                                .cornerRadius(30)
                        } else {
                            Circle().frame(width: lineWidth, height: lineWidth)
                        }
                    } else {
                        Spacer().frame(width: lineWidth)
                    }
                    if i != numberOfIntervals - 1{
                        Spacer().frame(width: distanceBetweenColumns + colWidth - lineWidth)
                    }
                }
                Spacer()
            }
            HStack {
                StartEndDateView(date: viewModel.model.startDate)
                Spacer()
                StartEndDateView(date: viewModel.model.endDate)
            }
        }.foregroundColor(Color("Light Gray"))
    }
    
    private struct StartEndDateView: View {
        let date: Date?
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            return formatter
        }()
        
        var body: some View {
            if date == nil {
                Text(" ")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            } else {
                Text(formatter.string(from: date!))
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
        }
    }
}

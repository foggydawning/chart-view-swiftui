//
//  chartView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct СhartView: View {
    let viewModel = СhartViewModel(
        model: .init(
            titleIcon: .init(systemName: "heart.fill"),
            titleText: "Пульс: сон",
            accentColor: .red,
            subtitles: ["Вот последние данные о Вашем пульсе во время сна."],
            minValue: (7,52),
            maxValue: (12,72)
        )
    )
    
    var body: some View {
        VStack{
            HStack{
                self.viewModel.model.titleIcon
                Text(self.viewModel.model.titleText)
                Spacer()
            }
        }
    }
}

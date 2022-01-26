//
//  ChartViewModel.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//


final class СhartViewModel {
    let model: СhartModel
    
    init(){
        self.model = СhartViewModel.fetchModel()
    }
}

extension СhartViewModel {
    private static func fetchModel() -> СhartModel{
        СhartModel(
            titleIcon: .init(systemName: "heart.fill"),
            titleText: "Пульс: сон",
            accentColor: .red,
            subtitles: ["Вот последние данные о Вашем пульсе во время сна."],
            minValue: (7,52),
            maxValue: (12,72)
        )
    }
}


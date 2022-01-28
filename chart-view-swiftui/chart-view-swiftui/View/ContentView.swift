//
//  ContentView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            ChartBlockView(viewModel: ChartBlockViewMovel(
                model: .init(
                    titleImageName: "heart.fill",
                    titleText: "Пульс: сон",
                    accentColor: Color("Heart"),
                    subtitle: "Вот последние данные о Вашем пульсе во время сна."),
                chartViewModel: .init()
            )).frame(width: UIScreen.main.bounds.width,
                     height: UIScreen.main.bounds.width)
        }
        .background(Color.gray)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

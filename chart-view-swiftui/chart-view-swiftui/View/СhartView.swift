//
//  ChartView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 26.01.2022.
//

import SwiftUI

struct СhartView: View {
    let viewModel = СhartViewModel()
    
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

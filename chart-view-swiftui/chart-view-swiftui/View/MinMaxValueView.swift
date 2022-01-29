//
//  MinMaxValueView.swift
//  chart-view-swiftui
//
//  Created by Илья Чуб on 28.01.2022.
//

import SwiftUI

struct MinMaxValueView: View {
    @ObservedObject var viewModel: MinMaxValueViewModel
    
    var body: some View {
        HStack(spacing: 0){
            Spacer().frame(width: viewModel.model.widthLeftSpacer)
            VStack{
                Text(viewModel.model.text)
                    .lineLimit(1)
                    .font(.system(size: 12, weight: .bold, design: .default))
                Text("\(Int(viewModel.model.value))")
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

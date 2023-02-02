//
//  ImageDetailView.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI

struct PinImageThumbView: View {
    @Environment(\.mainWindowSize) var mainWindowSize

    @ObservedObject var viewModel: CreateEditPinViewModel
    let col: Int
    let row: Int

    var body: some View {
        if let image = viewModel.image(col: col, row: row) {
            Button {
                withAnimation(.default) {
                    viewModel.detailIndex = row * 3 + col
                    viewModel.showImageDetails = true
                }
            } label: {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (mainWindowSize.width - (6 + UIProperties.Padding.medium.rawValue * 2)) / 3, height: 120)
                    .clipped()
            }
        } else {
            Spacer()
                .frame(maxWidth: .infinity)
        }
    }
}

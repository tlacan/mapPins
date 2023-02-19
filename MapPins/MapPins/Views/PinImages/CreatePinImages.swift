//
//  CreatePinImages.swift
//  MapPins
//
//  Created by thomas lacan on 19/02/2023.
//

import SwiftUI

struct CreatePinImages: View {
    @ObservedObject var viewModel: PinImagesViewModel

    struct ViewConstants {
        static let spacing: CGFloat = 2
        static let imagesPerRow = 3
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ViewConstants.spacing) {
            ForEach(0..<viewModel.imageRows + 1, id: \.self) { row in
                HStack(spacing: ViewConstants.spacing) {
                    ForEach(0..<ViewConstants.imagesPerRow, id: \.self) { col in
                        PinImageThumbView(viewModel: viewModel, col: col, row: row)
                    }
                }
            }
        }.frame(maxWidth: .infinity)
    }
}

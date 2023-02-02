//
//  PinImages15View.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI

struct PinImages15View: View {
    @ObservedObject var viewModel: CreateEditPinViewModel

    var body: some View {
        VStack(alignment: .leading) {
            L10n.CreatePin.images.swiftUISectionHeader()
            VStack(alignment: .leading, spacing: 2) {
                ForEach(0..<viewModel.imageRows + 1, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<3) { col in
                            PinImageThumbView(viewModel: viewModel, col: col, row: row)
                        }
                    }
                }
            }.frame(maxWidth: .infinity)
            HStack {
                ButtonView(image: UIImage(systemName: "photo"), text: L10n.CreatePin.Image.library) {
                    viewModel.showLibrary = true
                }
                ButtonView(image: UIImage(systemName: "camera"), text: L10n.CreatePin.Image.camera) {
                    viewModel.showCamera = true
                }
            }.frame(maxWidth: .infinity)
        }
    }
}

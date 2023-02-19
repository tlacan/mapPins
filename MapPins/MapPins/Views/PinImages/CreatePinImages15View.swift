//
//  PinImages15View.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI

struct CreatePinImages15View: View {
    @ObservedObject var viewModel: PinImagesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            L10n.CreatePin.images.swiftUISectionHeader()
            CreatePinImages(viewModel: viewModel)
            HStack {
                ButtonView(image: UIImage(systemSymbol: .photo), text: L10n.CreatePin.Image.library) {
                    viewModel.showLibrary = true
                }
                ButtonView(image: UIImage(systemSymbol: .camera), text: L10n.CreatePin.Image.camera) {
                    viewModel.showCamera = true
                }
            }.frame(maxWidth: .infinity)
        }
    }
}

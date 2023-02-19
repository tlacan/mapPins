//
//  PinImages16View.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct CreatePinImages16View: View {
    @ObservedObject var viewModel: PinImagesViewModel
    @State private var selectedItems = [PhotosPickerItem]()

    var body: some View {
        VStack(alignment: .leading) {
            L10n.CreatePin.images.swiftUISectionHeader()
            CreatePinImages(viewModel: viewModel)
            HStack {
                PhotosPicker(selection: $selectedItems, matching: .images) {
                    ButtonView(image: UIImage(systemSymbol: .photo), text: L10n.CreatePin.Image.library) {
                    }.disabled(true)
                }
                ButtonView(image: UIImage(systemSymbol: .camera), text: L10n.CreatePin.Image.camera) {
                    viewModel.showCamera = true
                }
            }.frame(maxWidth: .infinity)
        }.onChange(of: selectedItems) { items in
            Task {
                for item in items {
                    if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                        viewModel.images.append(image)
                    }
                }
                selectedItems.removeAll()
            }
        }
    }
}

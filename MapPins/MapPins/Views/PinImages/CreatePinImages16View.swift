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

    struct ViewConstants {
        static let spacing: CGFloat = 2
        static let imagesPerRow = 3
    }

    var body: some View {
        VStack(alignment: .leading) {
            L10n.CreatePin.images.swiftUISectionHeader()
            VStack(alignment: .leading, spacing: ViewConstants.spacing) {
                ForEach(0..<viewModel.imageRows + 1, id: \.self) { row in
                    HStack(spacing: ViewConstants.spacing) {
                        ForEach(0..<ViewConstants.imagesPerRow, id: \.self) { col in
                            PinImageThumbView(viewModel: viewModel, col: col, row: row)
                        }
                    }
                }
            }.frame(maxWidth: .infinity)
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

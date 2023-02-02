//
//  PinImages16View.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct PinImages16View: View {
    @StateObject var viewModel: CreateEditPinViewModel
    @State private var selectedItems = [PhotosPickerItem]()

    init(viewModel: CreateEditPinViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

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
                PhotosPicker(selection: $selectedItems, matching: .images) {
                    ButtonView(image: UIImage(systemName: "photo"), text: L10n.CreatePin.Image.library) {
                    }.disabled(true)
                }
                ButtonView(image: UIImage(systemName: "camera"), text: L10n.CreatePin.Image.camera) {
                    viewModel.showCamera = true
                }
            }.frame(maxWidth: .infinity)
        }.onChange(of: selectedItems) { items in
            Task {
                for item in items {
                    if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                        viewModel.selectedImages.append(image)
                    }
                }
                selectedItems.removeAll()
            }
        }
    }
}

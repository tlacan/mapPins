//
//  PinImagesDetailView.swift
//  MapPins
//
//  Created by thomas lacan on 15/02/2023.
//

import SwiftUI

struct PinImagesDetailView: View {
    @ObservedObject var viewModel: PinImagesViewModel
    let deleteButton: Bool

    init(viewModel: PinImagesViewModel, deleteButton: Bool) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.deleteButton = deleteButton
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            body16()
        } else {
            body15()
        }
    }

    @available(iOS 16.0, *)
    @ViewBuilder func body16() -> some View {
        NavigationStack {
            mainContent()
        }
    }

    @ViewBuilder func body15() -> some View {
        NavigationView {
            mainContent()
        }.navigationViewStyle(.stack)
    }

    @ViewBuilder func mainContent() -> some View {
        TabView(selection: $viewModel.detailIndex) {
            ForEach(0...viewModel.images.count - 1, id: \.self) { index in
                Image(uiImage: viewModel.images[index])
                    .fit()
                    .frame(maxWidth: .infinity)
            }
        }
            .navigationBarTitleDisplayMode(.inline)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    CloseButton {
                        viewModel.showImageDetails = false
                    }
                })
                ToolbarItem(placement: .bottomBar, content: {
                    if deleteButton {
                        ButtonView(image: UIImage(systemSymbol: .trash), text: L10n.General.delete) {
                            viewModel.deleteDetailImage()
                        }
                    }
                })
            })
    }
}

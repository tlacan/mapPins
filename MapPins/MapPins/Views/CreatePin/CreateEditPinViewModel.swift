//
//  CreateEditPinViewModel.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import Foundation
import UIKit
import SwiftUI

class CreateEditPinViewModel: ObservableObject {
    let editedPin: PinModel?
    let engine: Engine

    @Published var name: String {
        didSet {
            updateFormValid()
        }
    }
    @Published var address: AddressAutocompleteModel? {
        didSet {
            updateFormValid()
        }
    }
    @Published var category: PinCategory? {
        didSet {
            updateFormValid()
        }
    }
    @Published var rating: Double?
    @Published var formValid = false
    @Published var selectedImages: [UIImage]
    @Published var showImageDetails: Bool = false
    @Published var detailIndex = 0
    @Published var showCamera: Bool = false
    @Published var showLibrary: Bool = false

    init(engine: Engine, editedPin: PinModel?) {
        self.editedPin = editedPin
        self.engine = engine
        self.name = editedPin?.name ?? ""
        self.address = editedPin?.address
        self.category = editedPin?.category
        self.rating = editedPin?.rating
        self.selectedImages = editedPin?.images.compactMap({ UIImage(data: $0) }) ?? []
        updateFormValid()
    }

    var imageRows: Int {
        selectedImages.count % 3 == 0 ? selectedImages.count / 3 : (selectedImages.count / 3 + 1)
    }

    func updateFormValid() {
        withAnimation(.default) {
            if name.isEmpty || address == nil || category == nil {
                formValid = false
                return
            }
            formValid = true
        }
    }

    func image(col: Int, row: Int) -> UIImage? {
        let index = row * 3 + col
        if index < selectedImages.count {
            return selectedImages[index]
        }
        return nil
    }

    func savePin() async {
        guard var address = address, let category = category else { return }
        let images = selectedImages.compactMap({ $0.pngData() })
        await address.loadCoordinate()
        let newPin = PinModel(id: editedPin?.id ?? UUID(), name: name,
                              address: address, images: images, rating: rating, category: category)
        engine.pinService.savePin(newPin)
    }
}

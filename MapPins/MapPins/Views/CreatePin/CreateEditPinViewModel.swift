//
//  CreateEditPinViewModel.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
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

    init(engine: Engine, editedPin: PinModel?) {
        self.editedPin = editedPin
        self.engine = engine
        self.name = editedPin?.name ?? ""
        self.address = editedPin?.address
        self.category = editedPin?.category
        self.rating = editedPin?.rating
        updateFormValid()
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

    func savePin(images: [UIImage]) async {
        guard let address = address, let category = category else { return }
        let imagesData = images.compactMap({ $0.pngData() })
        let newPin = PinModel(id: editedPin?.id ?? UUID(), name: name,
                              address: address, images: imagesData, rating: rating, category: category)
        engine.pinService.savePin(newPin)
    }
}

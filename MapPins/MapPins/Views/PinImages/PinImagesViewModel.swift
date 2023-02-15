//
//  PinImagesViewModel.swift
//  MapPins
//
//  Created by thomas lacan on 15/02/2023.
//

import Foundation
import UIKit

class PinImagesViewModel: ObservableObject {
    @Published var showImageDetails: Bool = false
    @Published var detailIndex = 0
    @Published var images: [UIImage]
    @Published var showCamera: Bool = false
    @Published var showLibrary: Bool = false

    init(pin: PinModel?) {
        self.images = pin?.images.compactMap({ UIImage(data: $0) }) ?? []
    }

    var imageRows: Int {
        images.count % 3 == 0 ? images.count / 3 : (images.count / 3 + 1)
    }

    func image(col: Int, row: Int) -> UIImage? {
        images[safe: row * 3 + col]
    }

    func deleteDetailImage() {
        if images.count == 1 {
            showImageDetails = false
            detailIndex = 0
            images = []
            return
        }
        let indexToDelete = detailIndex
        if detailIndex == images.count - 1 {
            detailIndex -= 1
        }
        images.remove(at: indexToDelete)
    }
}

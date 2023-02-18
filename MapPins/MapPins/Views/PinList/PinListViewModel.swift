//
//  PinListViewModel.swift
//  MapPins
//
//  Created by thomas lacan on 18/02/2023.
//

import Foundation

@MainActor
class PinListViewModel: ObservableObject {
    let engine: Engine

    @Published var content: [String: [PinModel]] = [:]
    @Published var showPinDetail: Bool = false
    @Published var selectedPin: PinModel?
    @Published var search = ""

    init(engine: Engine) {
        self.engine = engine
    }

    func updateContent(pins: [PinModel], filterText: String?) {
        content.removeAll()
        var pins = pins.sorted(by: { $0.name.uppercased() < $1.name.uppercased() })
        if let filterText = filterText, !filterText.isEmpty {
            pins = pins.filter({ $0.name.lowercased().contains(filterText.lowercased()) })
        }
        pins = pins.filter(({ engine.preferenceService.isCategoryOn($0.category) }))

        for pin in pins {
            let index = pin.name.first?.uppercased() ?? " "
            if !content.keys.contains(index) {
                content[index] = [pin]
            } else {
                content[index]?.append(pin)
            }
        }
    }
}

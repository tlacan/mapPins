//
//  MapScreen.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI

struct MapScreen: View {
    @StateObject var viewModel: MapScreenViewModel
    let engine: Engine

    init(engine: Engine) {
        _viewModel = StateObject(wrappedValue: MapScreenViewModel(engine: engine))
        self.engine = engine
    }

    var body: some View {
        PinMapView(engine: engine, delegate: viewModel)
    }
}

class MapScreenViewModel: ObservableObject {
    let engine: Engine
    @Published var selectedPin: PinModel?

    init(engine: Engine, selectedPin: PinModel? = nil) {
        self.engine = engine
        self.selectedPin = selectedPin
    }
}

extension MapScreenViewModel: PinMapViewControllerDelegate {
    func didSelectPin(id: UUID) {
        selectedPin = engine.pinService.pins.responseArray?.first(where: { $0.id == id })
    }

}

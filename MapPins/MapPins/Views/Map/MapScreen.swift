//
//  MapScreen.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI

struct MapScreen: View {
    @State var showCreate: Bool = false
    @StateObject var viewModel: MapScreenViewModel
    let engine: Engine

    init(engine: Engine) {
        _viewModel = StateObject(wrappedValue: MapScreenViewModel(engine: engine))
        self.engine = engine
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PinMapView(engine: engine, delegate: viewModel)
            addButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showCreate) {
            CreateEditPinView(engine: engine)
        }
    }

    @ViewBuilder func addButton() -> some View {
        Button {
            showCreate = true
        } label: {
            ZStack {
                Circle()
                    .fill(XCAsset.Colors.background.swiftUIColor)
                Image(systemName: "plus")
                    .foregroundColor(XCAsset.Colors.black.swiftUIColor)
            }.frame(width: 32, height: 32)

        }.offset(x: -UIProperties.Padding.medium.rawValue, y: -UIProperties.Padding.medium.rawValue)
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

//
//  PinMapView.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI
import MapKit

struct PinMapView: UIViewControllerRepresentable {
    let engine: Engine
    let viewModel: MapScreenViewModel

    func makeUIViewController(context: UIViewControllerRepresentableContext<PinMapView>) -> PinMapViewController {
        PinMapViewController(engine: engine, viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: PinMapViewController, context: UIViewControllerRepresentableContext<PinMapView>) {

    }
}

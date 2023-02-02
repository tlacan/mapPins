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
    let delegate: PinMapViewControllerDelegate

    func makeUIViewController(context: UIViewControllerRepresentableContext<PinMapView>) -> PinMapViewController {
        PinMapViewController(engine: engine, delegate: delegate)
    }

    func updateUIViewController(_ uiViewController: PinMapViewController, context: UIViewControllerRepresentableContext<PinMapView>) {

    }
}

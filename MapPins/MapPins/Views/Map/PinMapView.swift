//
//  PinMapView.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI
import MapKit

struct PinMapView: View {
    let engine: Engine
    @StateObject var pinService: PinService
    @State var annotations: [PinModel]
    @State private var region = MKCoordinateRegion(center: UIProperties.Location.parisCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

    init(engine: Engine) {
        self.engine = engine
        _pinService = StateObject(wrappedValue: engine.pinService)
        annotations = []
    }

    var body: some View {
        EmptyView()
    }
}

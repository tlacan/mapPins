//
//  MapScreenViewModel.swift
//  MapPins
//
//  Created by thomas lacan on 15/02/2023.
//

import Foundation
import MapKit

@MainActor
class MapScreenViewModel: ObservableObject {
    let engine: Engine
    @Published var selectedPin: PinModel? {
        didSet {
            if selectedPin != nil {
                showSelected = true
                Task {
                    await computeEstimatedTime()
                }
            }
        }
    }
    @Published var showSelected: Bool = false
    @Published var directionsETA: MKDirections?
    @Published var directionsMap: MKDirections?
    @Published var estimatedTime: String?
    @Published var centerOnUser: Bool = true
    @Published var centerOnPin: PinModel?

    init(engine: Engine, selectedPin: PinModel? = nil) {
        self.engine = engine
        self.selectedPin = selectedPin
    }

    func computeEstimatedTime() async {
        guard let selectedPin = selectedPin,
              let pinLocation = selectedPin.address.coordinate,
              let userLocation = engine.geoLocationService.latestUserLocation else {
            directionsETA = nil
            estimatedTime = nil
            return
        }
        estimatedTime = nil
        let request = MKDirections.Request()
        request.departureDate = Date()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: pinLocation))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.transportType = engine.preferenceService.transportMode
        directionsETA = MKDirections(request: request)
        directionsMap = MKDirections(request: request)
        let response = try? await directionsETA?.calculateETA()
        estimatedTime = response?.expectedTravelTime.toString {
            $0.unitsStyle = .short
            $0.allowedUnits = [.hour, .minute]
            $0.locale = Locale.current
            $0.collapsesLargestUnit = true
            $0.allowsFractionalUnits = false
        }
    }

}

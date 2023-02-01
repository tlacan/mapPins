//
//  AddressAutocompleteModel.swift
//  MapPins
//
//  Created by thomas lacan on 20/01/2023.
//

import Foundation
import CoreLocation

struct AddressAutocompleteModel: Identifiable, Codable {
    var id = UUID()
    let title: String
    let subtitle: String
    var latitude: Double?
    var longitude: Double?

    mutating func coordinate() async -> CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        let geocoder = CLGeocoder()
        guard let location = try? await geocoder.geocodeAddressString("\(title) \(subtitle)")
            .compactMap({ $0.location })
            .first(where: { $0.horizontalAccuracy >= 0 }) else {
            return nil
        }
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude

        return location.coordinate
    }
}

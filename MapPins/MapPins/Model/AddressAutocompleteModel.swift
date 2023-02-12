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

    var coordinate: CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}

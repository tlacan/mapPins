//
//  PinModel.swift
//  MapPins
//
//  Created by thomas lacan on 20/01/2023.
//

import Foundation
import CoreLocation
import SwiftUI

struct PinModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var address: AddressAutocompleteModel
    var images: [Data]
    var rating: Double?
    var category: PinCategory
}

enum PinCategory: String, Codable, CaseIterable, Equatable {
    case restaurant
    case bakery
    case coffee
    case `bar`
    case site
    case accomodation
}

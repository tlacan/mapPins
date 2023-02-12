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

    var image: UIImage? {
        switch self {
        case .restaurant:
            return UIImage(systemName: "fork.knife")
        case .bakery:
            if #available(iOS 16, *) {
                return UIImage(systemName: "birthday.cake")
            } else {
                return XCAsset.Assets.croissant.image
            }
        case .coffee:
            return UIImage(systemName: "cup.and.saucer")
        case .bar:
            if #available(iOS 16, *) {
                return UIImage(systemName: "wineglass")
            } else {
                return XCAsset.Assets.cocktail.image
            }
        case .site:
            return UIImage(systemName: "building.columns")
        case .accomodation:
            return UIImage(systemName: "house")
        }
    }

    var uiText: String {
        switch self {
        case .restaurant:
            return L10n.Category.restaurant
        case .bakery:
            return L10n.Category.bakery
        case .coffee:
            return L10n.Category.coffee
        case .bar:
            return L10n.Category.bar
        case .site:
            return L10n.Category.site
        case .accomodation:
            return L10n.Category.accomodation
        }
    }

    var uiColor: Color {
        switch self {
        case .restaurant:
            return .red
        case .bakery:
            return .yellow
        case .coffee:
            return .brown
        case .bar:
            return .blue
        case .site:
            return .orange
        case .accomodation:
            return .green
        }
    }
}

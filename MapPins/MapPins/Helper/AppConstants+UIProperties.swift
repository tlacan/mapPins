//
//  Properties.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import Foundation
import CoreLocation
import StarRating
import SwiftUI
import MapKit
import SFSafeSymbols

struct AppConstants {
    enum Button: CGFloat {
        case height = 50
    }

    enum TextSize: CGFloat {
        case title = 25
        case sectionHeader = 18
        case description = 15
        case subtitle = 13
    }

    enum Padding: CGFloat {
        case verySmall = 8
        case small = 16
        case medium = 24
        case big = 32
        case veryBig = 64
    }

    enum Opacity: CGFloat {
        case disabled = 0.3
        case enabled = 1.0
    }

    enum Location {
        static let parisCenter = CLLocationCoordinate2D(latitude: 48.8444, longitude: 2.3333)
    }

    enum Star {
        static let configuration = StarRatingConfiguration(borderWidth: 1.0, borderColor: Color.yellow, shadowColor: Color.clear)
    }

    enum URLs: String {
        case googleMapApp = "comgooglemaps://"
        case googleMapAppCenter = "comgooglemaps-x-callback://?center="
        case googleMapCenter = "https://www.google.co.in/maps?center="
    }
}

extension MKDirectionsTransportType {
    var image: UIImage? {
        switch self {
        case .walking: return UIImage(systemSymbol: .figureWalk)
        case .automobile: return UIImage(systemSymbol: .car)
        default: return UIImage(systemSymbol: .tram)
        }
    }
}

extension PinCategory {
    var image: UIImage {
        switch self {
        case .restaurant:
            return UIImage(systemSymbol: .forkKnife)
        case .bakery:
            if #available(iOS 16, *) {
                return UIImage(systemSymbol: .birthdayCake)
            } else {
                return XCAsset.Assets.croissant.image
            }
        case .coffee:
            return UIImage(systemSymbol: .cupAndSaucer)
        case .bar:
            if #available(iOS 16, *) {
                return UIImage(systemSymbol: .wineglass)
            } else {
                return XCAsset.Assets.cocktail.image
            }
        case .site:
            return UIImage(systemSymbol: .buildingColumns)
        case .accomodation:
            return UIImage(systemSymbol: .house)
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

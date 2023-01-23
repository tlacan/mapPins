//
//  PinModel.swift
//  MapPins
//
//  Created by thomas lacan on 20/01/2023.
//

import Foundation
import CoreLocation
import UIKit

struct PinModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    var images: [String]
    var rating: Double
    var category: PinCategory

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum PinCategory: String, Codable {
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
            return UIImage(systemName: "birthday.cake")
        case .coffee:
            return UIImage(systemName: "cup.and.saucer")
        case .bar:
            return UIImage(systemName: "wineglass")
        case .site:
            return UIImage(systemName: "building.columns")
        case .accomodation:
            return UIImage(systemName: "house")
        }
    }
}

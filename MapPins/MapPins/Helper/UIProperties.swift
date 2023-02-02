//
//  Properties.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import Foundation
import CoreLocation

struct UIProperties {
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
}

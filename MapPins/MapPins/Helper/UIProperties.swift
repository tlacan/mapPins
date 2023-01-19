//
//  Properties.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import Foundation

struct UIProperties {
    enum TextSize: CGFloat {
        case title = 25
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
}

//
//  FileStoredData.swift
//  MapPins
//
//  Created by thomas lacan on 23/01/2023.
//

import Foundation

enum FileStoredData {
    case pins

    var path: String {
        switch self {
        case .pins: return "pins"
        }
    }
}

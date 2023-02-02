//
//  PinAnnotationView.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import Foundation
import MapKit

class PinAnnotationView: MKAnnotationView {
    static let kIdentifier = "Pin"

    override var annotation: MKAnnotation? {
        didSet {
            guard let mapItem = annotation as? MapItem else { return }
            clusteringIdentifier = PinAnnotationView.kIdentifier
            image = mapItem.image
        }
    }
}

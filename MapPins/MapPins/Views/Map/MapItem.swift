//
//  MapItem.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import Foundation
import MapKit
import CoreLocation

class MapItem: NSObject, MKAnnotation {
    let id: UUID
    let itemType: PinCategory

    dynamic var coordinate: CLLocationCoordinate2D
    dynamic var image: UIImage

    init(pin: PinModel) {
        self.itemType = pin.category
        self.coordinate = pin.address.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.id = pin.id
        self.image = UIImage(systemName: "mappin") ?? UIImage()
    }

    /*func updateImage() {
        image = itemType.icon
    }*/
}

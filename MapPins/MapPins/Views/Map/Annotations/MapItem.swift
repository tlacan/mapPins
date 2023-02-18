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
        self.image = UIImage()
        super.init()
        self.image = imageBuilder(category: itemType)
    }

    func imageBuilder(category: PinCategory) -> UIImage {
        let pinImage = XCAsset.Assets.pin.image.preparingThumbnail(of: CGSize(width: 45, height: 45)) ?? XCAsset.Assets.pin.image

        var catagoryImage = category.image
        catagoryImage = catagoryImage.preparingThumbnail(of: CGSize(width: 24, height: 24)) ?? catagoryImage
        catagoryImage = catagoryImage.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        return pinImage.withRenderingMode(.alwaysTemplate).withTintColor(UIColor(category.uiColor)).mergeImage(with: catagoryImage, offsetY: -5)
    }
}

//
//  UIImage+Helper.swift
//  MapPins
//
//  Created by thomas lacan on 04/02/2023.
//

import Foundation
import UIKit

extension UIImage {

    func mergeImage(with secondImage: UIImage, point: CGPoint? = nil) -> UIImage {
        let firstImage = self
        let newImageWidth = max(firstImage.size.width, secondImage.size.width)
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)
        let deviceScale = UIScreen.main.scale

        UIGraphicsBeginImageContextWithOptions(newImageSize, false, deviceScale)
        let firstImagePoint = CGPoint(x: round((newImageSize.width - firstImage.size.width) / 2),
                                      y: round((newImageSize.height - firstImage.size.height) / 2))

        let secondImagePoint = point ?? CGPoint(x: round((newImageSize.width - secondImage.size.width) / 2),
                                                y: round((newImageSize.height - secondImage.size.height) / 2))

        firstImage.draw(at: firstImagePoint)
        secondImage.draw(at: secondImagePoint)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? self
    }
}

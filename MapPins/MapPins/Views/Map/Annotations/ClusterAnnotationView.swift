//
//  ClusterAnnotationView.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import Foundation
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    static let kIdentifier = "cluster"

    override var annotation: MKAnnotation? {
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }
            displayPriority = .defaultHigh
            let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
            image = UIGraphicsImageRenderer.image(for: cluster.memberAnnotations, in: rect)
        }
    }
}

extension UIGraphicsImageRenderer {
    static func image(for annotations: [MKAnnotation]?, in rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let image = UIImage.circle(diameter: 40, color: .lightGray)

        return renderer.image { _ in
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            if annotations != nil {
                String(annotations?.count ?? 0).drawForCluster(in: rect)
            }
        }
    }
}

extension String {
    func drawForCluster(in rect: CGRect) {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let textSize = self.size(withAttributes: attributes)
        let textRect = CGRect(x: (rect.width / 2) - (textSize.width / 2),
                              y: (rect.height / 2) - (textSize.height / 2),
                              width: textSize.width,
                              height: textSize.height)

        self.draw(in: textRect, withAttributes: attributes)
    }
}

extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()

        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)

        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return img
    }
}

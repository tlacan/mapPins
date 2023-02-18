//
//  FooterGradient.swift
//  MapPins
//
//  Created by thomas lacan on 01/02/2023.
//

import SwiftUI

struct FooterGradient: View {
    var body: some View {
        Rectangle().fill(
             LinearGradient(gradient:
                Gradient(stops: [
                    .init(color: XCAsset.Colors.background.swiftUIColor.opacity(0.01), location: 0),
                    .init(color: XCAsset.Colors.background.swiftUIColor, location: 0.3)
             ]), startPoint: .top, endPoint: .bottom)
        )
            .frame(height: AppConstants.Button.height.rawValue + AppConstants.Padding.medium.rawValue * 2)
            .frame(maxWidth: .infinity)
            .allowsHitTesting(false)
    }
}

struct FooterGradient_Previews: PreviewProvider {
    static var previews: some View {
        FooterGradient()
    }
}

//
//  BackButton.swift
//  MapPins
//
//  Created by thomas lacan on 27/01/2023.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemSymbol: .chevronBackwardCircleFill)
                .foregroundColor(XCAsset.Colors.black.swiftUIColor)
        }
    }
}

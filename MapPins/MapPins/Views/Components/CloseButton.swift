//
//  CloseButton.swift
//  MapPins
//
//  Created by thomas lacan on 27/01/2023.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(XCAsset.Colors.black.swiftUIColor)
        }
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(action: {})
    }
}

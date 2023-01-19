//
//  ButtonView.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import SwiftUI

struct ButtonView: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: UIProperties.TextSize.description.rawValue))
                .foregroundColor(XCAsset.Colors.background.swiftUIColor)
                .padding(.horizontal)
        }
            .frame(height: 50)
            .background(XCAsset.Colors.text.swiftUIColor           .cornerRadius(24))
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Sample", action: {})
    }
}

//
//  ButtonView.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import SwiftUI

struct ButtonView: View {
    let image: UIImage?
    let text: String
    let action: () -> Void

    init(image: UIImage? = nil, text: String, action: @escaping () -> Void) {
        self.image = image
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let image = image {
                    Image(uiImage: image)
                        .renderingMode(.template)
                        .foregroundColor(XCAsset.Colors.background.swiftUIColor)
                        .padding(.leading)
                }
                Text(text)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: UIProperties.TextSize.description.rawValue))
                    .foregroundColor(XCAsset.Colors.background.swiftUIColor)
                    .padding(.horizontal)
            }
        }
            .frame(height: UIProperties.Button.height.rawValue)
            .background(XCAsset.Colors.text.swiftUIColor           .cornerRadius(24))
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Sample", action: {})
    }
}

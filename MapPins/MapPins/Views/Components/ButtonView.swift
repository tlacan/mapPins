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

    struct ViewConstants {
        static let minFontScale = 0.2
        static let lineLimit = 2
        static let radius: CGFloat = 24
    }

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
                    .minimumScaleFactor(ViewConstants.minFontScale)
                    .lineLimit(ViewConstants.lineLimit)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: AppConstants.TextSize.description.rawValue))
                    .foregroundColor(XCAsset.Colors.background.swiftUIColor)
                    .padding(image != nil ? .trailing : .horizontal)
            }
        }
            .frame(height: AppConstants.Button.height.rawValue)
            .background(XCAsset.Colors.text.swiftUIColor.cornerRadius(ViewConstants.radius))
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Sample", action: {})
    }
}

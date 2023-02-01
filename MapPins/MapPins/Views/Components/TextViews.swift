//
//  TextViews.swift
//  MapPins
//
//  Created by thomas lacan on 19/01/2023.
//

import Foundation
import SwiftUI

extension String {
    func swiftUITitle() -> some View {
        Text(self)
            .font(FontFamily.Poppins.bold.swiftUIFont(size: UIProperties.TextSize.title.rawValue))
            .foregroundColor(XCAsset.Colors.text.swiftUIColor)
    }

    func swiftUISectionHeader() -> some View {
        Text(self)
            .font(FontFamily.Poppins.bold.swiftUIFont(size: UIProperties.TextSize.sectionHeader.rawValue))
            .foregroundColor(XCAsset.Colors.text.swiftUIColor)
    }

    func swiftUIDescription() -> some View {
        Text(self)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: UIProperties.TextSize.description.rawValue))
            .foregroundColor(XCAsset.Colors.text.swiftUIColor)
    }

    func swiftUISubtitle() -> some View {
        Text(self)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: UIProperties.TextSize.subtitle.rawValue))
            .foregroundColor(Color(UIColor.systemGray2))
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            "Title".swiftUITitle()
            "Description".swiftUITitle()
        }
    }
}

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
            .font(FontFamily.Poppins.bold.swiftUIFont(size: AppConstants.TextSize.title.rawValue))
            .foregroundColor(XCAsset.Colors.text.swiftUIColor)
    }

    func swiftUISectionHeader() -> some View {
        Text(self)
            .font(FontFamily.Poppins.bold.swiftUIFont(size: AppConstants.TextSize.sectionHeader.rawValue))
            .foregroundColor(XCAsset.Colors.text.swiftUIColor)
    }

    func swiftUIDescription() -> some View {
        Text(self)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: AppConstants.TextSize.description.rawValue))
            .foregroundColor(XCAsset.Colors.text.swiftUIColor)
    }

    func swiftUISubtitle() -> some View {
        Text(self)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: AppConstants.TextSize.subtitle.rawValue))
            .foregroundColor(Color(UIColor.systemGray2))
    }

    func swiftUIEmptyList() -> some View {
        Text(self)
            .foregroundColor(Color(uiColor: UIColor.systemGray2))
            .font(.system(size: 28.0))
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

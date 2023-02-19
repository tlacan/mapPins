//
//  View+Helper.swift
//  MapPins
//
//  Created by thomas lacan on 15/02/2023.
//

import SwiftUI

extension View {
    func `if`<ContentA: View, ContentB: View>(_ conditional: Bool, success: (Self) -> ContentA, failure: (Self) -> ContentB) -> some View {
        conditional ? AnyView(success(self)) : AnyView(failure(self))
    }

    func `if`<Content: View>(_ value: Any?, _ success: (Self) -> Content) -> some View {
        value == nil ? AnyView(self) : AnyView(success(self))
    }

    func `if`<Content: View>(_ condition: Bool, _ success: (Self) -> Content) -> some View {
        !condition ? AnyView(self) : AnyView(success(self))
    }

    func outerShaddow(radius: CGFloat = 5, offset: CGFloat = 5, opacityDark: CGFloat = 0.2, opacityLight: CGFloat = 0.2) -> some View {
        self
        .shadow(color: XCAsset.Colors.black.swiftUIColor.opacity(opacityDark), radius: radius, x: offset, y: offset)
        .shadow(color: XCAsset.Colors.background.swiftUIColor.opacity(opacityLight), radius: radius, x: -offset, y: -offset)
    }
}

extension SwiftUI.Image {
    func fit(width: CGFloat? = nil, height: CGFloat? = nil, foregroundColor: Color? = nil) -> some View {
        self
        .resizable()
        .renderingMode(.template)
        .scaledToFit()
        .if(foregroundColor) { view in
            view.foregroundColor(foregroundColor)
        }
        .if(height) { view in
            view.frame(height: height)
        }
        .if(width) { view in
            view.frame(width: width)
        }
    }
}

extension UIView {
    static func removeFocus() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

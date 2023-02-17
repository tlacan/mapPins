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
}


extension UIView {
    static func removeFocus() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

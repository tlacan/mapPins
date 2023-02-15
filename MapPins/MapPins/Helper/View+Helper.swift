//
//  View+Helper.swift
//  MapPins
//
//  Created by thomas lacan on 15/02/2023.
//

import SwiftUI

extension UIView {
    static func removeFocus() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

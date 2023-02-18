//
//  EmptyList.swift
//  MapPins
//
//  Created by thomas lacan on 26/01/2023.
//

import SwiftUI

struct EmptyListModifier<EmptyListView: View>: ViewModifier {
    let displayEmptyList: Bool
    let emptyListView: () -> EmptyListView

    public func body(content: Content) -> some View {
        ZStack {
            content
            if displayEmptyList {
                emptyListView()
            }
        }
    }
}

extension View {
    func emptyListView<EmptyListView: View>(displayEmptyList: Bool,
        emptyListView: @escaping () -> EmptyListView = { L10n.General.noResult.swiftUIEmptyList() }) -> ModifiedContent<Self, EmptyListModifier<EmptyListView>> {
        modifier(EmptyListModifier(displayEmptyList: displayEmptyList, emptyListView: emptyListView)
        )
    }
}

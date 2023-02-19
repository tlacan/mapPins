//
//  PinFilterView.swift
//  MapPins
//
//  Created by thomas lacan on 08/02/2023.
//

import SwiftUI

struct PinMapFilterView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var preferencesService: PreferenceService
    let engine: Engine

    init(engine: Engine) {
        self.engine = engine
        _preferencesService = ObservedObject(wrappedValue: engine.preferenceService)
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            body16()
        } else {
            body15()
        }
    }

    @available(iOS 16.0, *)
    @ViewBuilder func body16() -> some View {
        NavigationStack {
            mainContent()
        }
    }

    @ViewBuilder func body15() -> some View {
        NavigationView {
            mainContent()
        }.navigationViewStyle(.stack)
    }

    @ViewBuilder func mainContent() -> some View {
        List {
            ForEach(PinCategory.allCases, id: \.self.rawValue) { category in
                categoryItem(category)
            }
        }.listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                L10n.PinFilterView.title.swiftUITitle()
            }
            ToolbarItem(placement: .cancellationAction) {
                CloseButton {
                    dismiss()
                }
            }
        }
    }

    @ViewBuilder func categoryItem(_ category: PinCategory) -> some View {
        Toggle(isOn: Binding(get: {
            preferencesService.isCategoryOn(category)
        }, set: { value, _ in
            preferencesService.updateFilter(category: category, add: value)
        })) {
            Text(category.uiText)
        }.toggleStyle(SwitchToggleStyle())
    }
}

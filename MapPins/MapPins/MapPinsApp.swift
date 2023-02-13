//
//  MapPinsApp.swift
//  MapPins
//
//  Created by thomas lacan on 11/01/2023.
//

import SwiftUI
import PartialSheet

struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
}

@main
struct MapPinsApp: App {
    let engine = Engine()

    var body: some Scene {
        WindowGroup {
            GeometryReader { geo in
                if #available(iOS 16.0, *) {
                    ContentView(engine: engine)
                        .environment(\.mainWindowSize, geo.size)
                } else {
                    ContentView(engine: engine)
                        .environment(\.mainWindowSize, geo.size)
                        .attachPartialSheetToRoot()
                }
            }
        }
    }
}

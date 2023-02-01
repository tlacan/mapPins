//
//  MapPinsApp.swift
//  MapPins
//
//  Created by thomas lacan on 11/01/2023.
//

import SwiftUI

@main
struct MapPinsApp: App {
    let engine = Engine()

    var body: some Scene {
        WindowGroup {
            ContentView(engine: engine)
        }
    }
}

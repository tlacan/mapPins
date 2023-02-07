//
//  ContentView.swift
//  MapPins
//
//  Created by thomas lacan on 11/01/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(UserDefaultsKeys.onboardingCompleted.rawValue) var onboardingCompleted: Bool = false
    let engine: Engine

    var body: some View {
        ZStack {
            if onboardingCompleted {
                TabView {
                    MapScreen(engine: engine)
                        .tabItem {
                            Label(L10n.Tab.Map.title, systemImage: "map.fill")
                        }

                    PinListView(engine: engine)
                        .tabItem {
                            Label(L10n.Tab.List.title, systemImage: "list.bullet")
                        }
                    Text("toto")
                        .tabItem {
                            Label(L10n.Tab.Settings.title, systemImage: "gearshape.fill")
                        }
                }
            } else {
                OnboardingIntroView()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

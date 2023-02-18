//
//  ContentView.swift
//  MapPins
//
//  Created by thomas lacan on 11/01/2023.
//

import SwiftUI

struct ContentView: View {
    enum Tab {
        case map
        case list
        case settings
    }

    @AppStorage(UserDefaultsKeys.onboardingCompleted.rawValue) var onboardingCompleted: Bool = false
    @State private var tabSelection = Tab.map

    let engine: Engine

    var body: some View {
        ZStack {
            if onboardingCompleted {
                TabView(selection: $tabSelection) {
                    MapScreen(engine: engine)
                        .tabItem {
                            Label(L10n.Tab.Map.title, systemImage: "map.fill")
                        }.tag(Tab.map)
                    PinListView(engine: engine)
                        .tabItem {
                            Label(L10n.Tab.List.title, systemImage: "list.bullet")
                        }.tag(Tab.list)
                    SettingsScreen(engine: engine)
                        .tabItem {
                            Label(L10n.Tab.Settings.title, systemImage: "gearshape.fill")
                        }.tag(Tab.settings)
                }
            } else {
                OnboardingIntroView()
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(NotificationConstants.showPinOnMap.publisher) { _ in
                Task { @MainActor in
                    withAnimation {
                        tabSelection = Tab.map
                    }
                }
            }
    }
}

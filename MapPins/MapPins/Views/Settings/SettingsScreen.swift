//
//  SettingsScreen.swift
//  MapPins
//
//  Created by thomas lacan on 13/02/2023.
//

import SwiftUI
import AckGenUI
import MapKit

struct SettingsScreen: View {
    let engine: Engine
    let transportModes = [MKDirectionsTransportType.automobile, MKDirectionsTransportType.walking, MKDirectionsTransportType.transit]

    @State var transportMode: UInt
    @State var showAcknowledgement: Bool = false

    init(engine: Engine) {
        self.engine = engine
        _transportMode = State(wrappedValue: engine.preferenceService.transportMode.rawValue)
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
            ZStack {
                NavigationLink(isActive: $showAcknowledgement) {
                    AcknowledgementsList()
                } label: {
                    EmptyView()
                }
                mainContent()
            }
        }
    }

    @ViewBuilder func mainContent() -> some View {
        List {
            transportModeEntry()
            acknowledgementsEntry()
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.Tab.Settings.title)
    }

    @ViewBuilder func transportModeEntry() -> some View {
        HStack {
            Text(L10n.Settings.TransportMode.entry)
                .frame(maxWidth: .infinity, alignment: .leading)

            Picker(L10n.Settings.TransportMode.entry, selection: Binding(get: {
                transportMode
            }, set: { value in
                transportMode = value
                engine.preferenceService.transportMode = MKDirectionsTransportType(rawValue: value)
            })) {
                ForEach(transportModes, id: \.self.rawValue) { transportMode in
                    if let image = transportMode.image {
                        Image(uiImage: image)
                            .tag(transportMode.rawValue)
                    }
                }
            }.pickerStyle(.segmented)
        }
    }

    @ViewBuilder func acknowledgementsEntry() -> some View {
        NavigationLink {
            AcknowledgementsList()
        } label: {
            Text(L10n.Settings.Acknowledgements.entry)
        }
    }
}

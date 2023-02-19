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
    @Environment(\.colorScheme) var colorScheme

    let engine: Engine
    let transportModes = [MKDirectionsTransportType.automobile, MKDirectionsTransportType.walking, MKDirectionsTransportType.transit]
    @ObservedObject var geolocationService: GeoLocationService

    @State var transportMode: UInt
    @State var showAcknowledgement: Bool = false

    init(engine: Engine) {
        self.engine = engine
        _geolocationService = ObservedObject(wrappedValue: engine.geoLocationService)
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
                Color(uiColor: .systemBackground).ignoresSafeArea()
                NavigationLink(isActive: $showAcknowledgement) {
                    AcknowledgementsList()
                } label: {
                    EmptyView()
                }
                mainContent()
            }
        }.navigationViewStyle(.stack)
    }

    @ViewBuilder func mainContent() -> some View {
        List {
            Section {
                transportModeEntry()
                localisation()
                acknowledgementsEntry()
            } footer: {
                version()
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(L10n.Tab.Settings.title)
    }

    @ViewBuilder func localisation() -> some View {
        Button {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else {
                return
            }
            UIApplication.shared.open(settingsUrl)
        } label: {
            HStack {
                Text(L10n.Settings.Localisation.entry)
                    .foregroundColor(colorScheme == .dark ? Color.white : XCAsset.Colors.text.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if geolocationService.locationManager.authorizationStatus == .authorizedWhenInUse {
                    Text(L10n.Settings.Localisation.whenInUse)
                        .foregroundColor(XCAsset.Colors.text.swiftUIColor)
                } else if geolocationService.locationManager.authorizationStatus == .authorizedAlways {
                    Text(L10n.Settings.Localisation.always)
                } else {
                    Text(L10n.Settings.Localisation.denied)
                }
            }
        }
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

    func version() -> some View {
        let version = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
        let build = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")
        guard let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String else {
            return AnyView(EmptyView())
        }
        return AnyView(
            Text("\(name) v\(version)-\(build)")
                .frame(maxWidth: .infinity)
        )
    }
}

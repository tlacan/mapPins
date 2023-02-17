//
//  MapScreen.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI
import PartialSheet
import MapKit
import SwiftDate

struct MapScreen: View {
    @State var showCreate: Bool = false
    @State var showFilter: Bool = false
    @StateObject var viewModel: MapScreenViewModel
    @ObservedObject var preferenceService: PreferenceService
    @ObservedObject var geolocationService: GeoLocationService

    let engine: Engine

    init(engine: Engine) {
        _viewModel = StateObject(wrappedValue: MapScreenViewModel(engine: engine))
        _preferenceService = ObservedObject(wrappedValue: engine.preferenceService)
        _geolocationService = ObservedObject(wrappedValue: engine.geoLocationService)
        self.engine = engine
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
        mainContent()
            .sheet(isPresented: $viewModel.showSelected) {
                if let selected = viewModel.selectedPin {
                    MapPinSelectedView(engine: engine, pin: selected, viewModel: viewModel)
                        .presentationDetents([.fraction(0.33), .medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
    }

    @ViewBuilder func body15() -> some View {
        mainContent()
            .partialSheet(isPresented: $viewModel.showSelected) {
                if let selected = viewModel.selectedPin {
                    MapPinSelectedView(engine: engine, pin: selected, viewModel: viewModel)
                }
            }
    }

    @ViewBuilder func mainContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            PinMapView(engine: engine, viewModel: viewModel)
                .edgesIgnoringSafeArea(.top)
            sideButtons()
                .offset(x: -UIProperties.Padding.medium.rawValue, y: -UIProperties.Padding.medium.rawValue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showCreate) {
            CreateEditPinView(engine: engine, editedPin: nil)
        }
        .sheet(isPresented: $showFilter) {
            PinFilterView(engine: engine)
        }
        .onAppear {
            engine.geoLocationService.startUpdateLocationIfNeeded(continuous: true)
        }
        .onDisappear {
            engine.geoLocationService.stopUpdateLocation()
        }
    }

    @ViewBuilder func sideButtons() -> some View {
        VStack {
            if geolocationService.latestUserLocation != nil {
                sideButton(imageSystemName: "location") {
                    viewModel.centerOnUser = true
                }
            }
            filterButton()
            sideButton(imageSystemName: "plus") {
                showCreate = true
            }
        }
    }

    @ViewBuilder func sideButton(imageSystemName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(XCAsset.Colors.background.swiftUIColor)
                Image(systemName: imageSystemName)
                    .foregroundColor(XCAsset.Colors.black.swiftUIColor)
            }.frame(width: 40, height: 40)
        }
    }

    @ViewBuilder func filterButton() -> some View {
        ZStack {
            sideButton(imageSystemName: "ellipsis") {
                showFilter = true
            }
            if !preferenceService.noActiveFilters {
                ZStack {
                    Circle()
                        .fill(XCAsset.Colors.black.swiftUIColor)
                    Text("\(preferenceService.filters.count)")
                        .font(.system(size: 10))
                        .foregroundColor(XCAsset.Colors.background.swiftUIColor)
                }.frame(width: 16, height: 16)
                    .offset(x: 18, y: 18)
            }
        }
    }
}

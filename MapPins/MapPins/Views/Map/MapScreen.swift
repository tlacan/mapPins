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

    struct ViewConstants {
        struct SideButton {
            static let size: CGFloat = 40
        }
        struct FilterButton {
            static let size: CGFloat = 16
            static let offsetXY: CGFloat = 18
            static let textFont: SwiftUI.Font = .system(size: 10)
        }
    }

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
                .offset(x: -AppConstants.Padding.medium.rawValue, y: -AppConstants.Padding.medium.rawValue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showCreate) {
            CreateEditPinView(engine: engine, editedPin: nil)
        }
        .sheet(isPresented: $showFilter) {
            PinMapFilterView(engine: engine)
        }
        .onAppear {
            engine.geoLocationService.startUpdateLocationIfNeeded(continuous: true)
        }
        .onDisappear {
            engine.geoLocationService.stopUpdateLocation()
        }
        .onReceive(NotificationConstants.showPinOnMap.publisher) { notification in
            Task { @MainActor in
                withAnimation(.default) {
                    if let pin = notification.object as? PinModel {
                        viewModel.showSelected = false
                        viewModel.centerOnPin = pin
                    }
                }
            }
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
            }.frame(width: ViewConstants.SideButton.size, height: ViewConstants.SideButton.size)
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
                        .font(ViewConstants.FilterButton.textFont)
                        .foregroundColor(XCAsset.Colors.background.swiftUIColor)
                }.frame(width: ViewConstants.FilterButton.size, height: ViewConstants.FilterButton.size)
                    .offset(x: ViewConstants.FilterButton.offsetXY, y: ViewConstants.FilterButton.offsetXY)
            }
        }
    }
}

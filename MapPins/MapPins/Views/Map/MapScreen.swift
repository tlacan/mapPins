//
//  MapScreen.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import SwiftUI
import PartialSheet

struct MapScreen: View {
    @State var showCreate: Bool = false
    @State var showFilter: Bool = false
    @StateObject var viewModel: MapScreenViewModel
    @ObservedObject var preferenceService: PreferenceService
    let engine: Engine

    init(engine: Engine) {
        _viewModel = StateObject(wrappedValue: MapScreenViewModel(engine: engine))
        _preferenceService = ObservedObject(wrappedValue: engine.preferenceService)
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
                selectedPinSheetContent()
                    .presentationDetents([.height(200)])
                    .presentationDragIndicator(.visible)

            }
    }

    @ViewBuilder func body15() -> some View {
        mainContent()
            .partialSheet(isPresented: $viewModel.showSelected) {
                selectedPinSheetContent()
            }
    }

    @ViewBuilder func mainContent() -> some View {
        ZStack(alignment: .bottomTrailing) {
            PinMapView(engine: engine, delegate: viewModel)
            VStack {
                filterButton()
                addButton()
            }.offset(x: -UIProperties.Padding.medium.rawValue, y: -UIProperties.Padding.medium.rawValue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showCreate) {
            CreateEditPinView(engine: engine)
        }
        .sheet(isPresented: $showFilter) {
            PinFilterView(engine: engine)
        }
    }

    @ViewBuilder func selectedPinSheetContent() -> some View {
        VStack {
            Text(viewModel.selectedPin?.name ?? "")
        }
    }

    @ViewBuilder func filterButton() -> some View {
        Button {
            showFilter = true
        } label: {
            ZStack {
                Circle()
                    .fill(XCAsset.Colors.background.swiftUIColor)
                Image(systemName: "ellipsis")
                    .foregroundColor(XCAsset.Colors.black.swiftUIColor)
                if !preferenceService.allValues {
                    ZStack {
                        Circle()
                            .fill(XCAsset.Colors.black.swiftUIColor)
                        Text("\(preferenceService.filters.count)")
                            .font(.system(size: 10))
                            .foregroundColor(XCAsset.Colors.background.swiftUIColor)
                    }.frame(width: 16, height: 16)
                        .offset(x: 18, y: 18)
                }
            }.frame(width: 40, height: 40)
        }
    }

    @ViewBuilder func addButton() -> some View {
        Button {
            showCreate = true
        } label: {
            ZStack {
                Circle()
                    .fill(XCAsset.Colors.background.swiftUIColor)
                Image(systemName: "plus")
                    .foregroundColor(XCAsset.Colors.black.swiftUIColor)
            }.frame(width: 40, height: 40)
        }
    }
}

@MainActor
class MapScreenViewModel: ObservableObject {
    let engine: Engine
    @Published var selectedPin: PinModel?
    @Published var showSelected: Bool = false

    init(engine: Engine, selectedPin: PinModel? = nil) {
        self.engine = engine
        self.selectedPin = selectedPin
    }
}

extension MapScreenViewModel: PinMapViewControllerDelegate {
    func didSelectPin(id: UUID) {
        withAnimation(.default) {
            selectedPin = engine.pinService.pins.responseArray?.first(where: { $0.id == id })
            showSelected = true
        }
    }

}

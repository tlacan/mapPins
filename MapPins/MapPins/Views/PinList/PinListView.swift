//
//  PinListView.swift
//  MapPins
//
//  Created by thomas lacan on 05/02/2023.
//

import SwiftUI
import Neumorphic

struct PinListView: View {
    let engine: Engine
    @State var showCreate: Bool = false

    @StateObject var viewModel: PinListViewModel
    @ObservedObject var pinService: PinService
    @ObservedObject var preferencesService: PreferenceService

    struct ViewConstants {
        struct Filter {
            static let height: CGFloat = 48
            static let imageHeight: CGFloat = 24
            static let shaddowOuterOffset: CGFloat = 5
            static let shaddowOuterRadius: CGFloat = 5
        }

        struct PinItem {
            static let imageHeight: CGFloat = 24
        }
    }

    init(engine: Engine) {
        self.engine = engine
        _viewModel = StateObject(wrappedValue: PinListViewModel(engine: engine))
        _pinService = ObservedObject(wrappedValue: engine.pinService)
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
                .scrollIndicators(.hidden)
                .navigationDestination(isPresented: $viewModel.showPinDetail, destination: {
                    if let pin = viewModel.selectedPin {
                        CreateEditPinView(engine: engine, editedPin: pin)
                    }
                })
        }
    }

    @ViewBuilder func body15() -> some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $viewModel.showPinDetail, destination: {
                    if let pin = viewModel.selectedPin {
                        CreateEditPinView(engine: engine, editedPin: pin)
                    }
                }) { EmptyView() }
                mainContent()
                    .introspectTableView { tableView in
                        tableView.showsVerticalScrollIndicator = false
                    }
            }
        }
    }

    @ViewBuilder func mainContent() -> some View {
        ScrollViewReader { proxy in
            List {
                filters().listRowBackground(Color.clear)
                ForEach(viewModel.content.keys.sorted(by: { $0 < $1 }), id: \.self) { letter in
                    Section(letter) {
                        ForEach(viewModel.content[letter] ?? []) { pin in
                            pinItem(pin)
                        }
                    }.id(letter)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .firstLetterSectionIndex(proxy: proxy, sections: viewModel.content.keys.sorted(by: { $0 < $1 }))
            .emptyListView(displayEmptyList: viewModel.content.isEmpty)
        }.task {
            viewModel.updateContent(pins: pinService.pins.responseArray ?? [], filterText: viewModel.search)
        }
        .onReceive(pinService.$pins, perform: { pins in
            viewModel.updateContent(pins: pinService.pins.responseArray ?? [], filterText: viewModel.search)
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showCreate = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showCreate, content: {
            CreateEditPinView(engine: engine, editedPin: nil)
        })
        .navigationTitle(L10n.List.title)
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: L10n.Search.placeholder)
        .onReceive(viewModel.$search.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) {
            viewModel.updateContent(pins: pinService.pins.responseArray ?? [], filterText: $0)
        }
        .autocorrectionDisabled()
    }

    @ViewBuilder func filters() -> some View {
        ScrollView {
            HStack {
                ForEach(PinCategory.allCases, id: \.self) { category in
                    filter(category: category)
                }
                Spacer()
            }.frame(maxWidth: .infinity)
        }
    }

    func filter(category: PinCategory) -> some View {
        let isOn = preferencesService.isCategoryOn(category)

        return Button {
            withAnimation(.default) {
                preferencesService.updateFilter(category: category, add: !isOn)
                viewModel.updateContent(pins: pinService.pins.responseArray ?? [], filterText: viewModel.search)
            }
        } label: {
            ZStack {
                if isOn {
                    Circle()
                        .fill(Color.Neumorphic.main)
                        .clipShape(Circle())
                        .softInnerShadow(Circle())
                        .frame(height: ViewConstants.Filter.height)
                } else {
                    Circle()
                        .fill(Color.Neumorphic.main)
                        .clipShape(Circle())
                        .softOuterShadow(offset: ViewConstants.Filter.shaddowOuterOffset, radius: ViewConstants.Filter.shaddowOuterRadius)
                        .frame(height: ViewConstants.Filter.height)
                }
                Image(uiImage: category.image)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundColor(Color.gray)
                    .frame(height: ViewConstants.Filter.imageHeight)
            }
        }.padding(.vertical)
    }

    @ViewBuilder func pinItem(_ pin: PinModel) -> some View {
        Button {
            withAnimation(.default) {
                viewModel.selectedPin = pin
                viewModel.showPinDetail = true
            }
        } label: {
            HStack {
                if let image = pin.category.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: ViewConstants.PinItem.imageHeight)
                }
                Text(pin.name.capitalized)
                    .foregroundColor(XCAsset.Colors.text.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.forward")
                    .foregroundColor(Color.gray)
            }.swipeActions {
                Button("Burn") {

                }
                .tint(.red)
            }
        }
    }
}

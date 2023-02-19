//
//  PinListView.swift
//  MapPins
//
//  Created by thomas lacan on 05/02/2023.
//

import SwiftUI
import Neumorphic

struct PinListView: View {
    @Environment(\.colorScheme) var colorScheme

    let engine: Engine
    @State var showCreate: Bool = false

    @StateObject var viewModel: PinListViewModel
    @ObservedObject var pinService: PinService
    @ObservedObject var preferencesService: PreferenceService

    struct ViewConstants {
        struct Filter {
            static let height: CGFloat = 48
            static let imageHeight: CGFloat = 24
        }

        struct PinItem {
            static let size: CGFloat = 24
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
            ZStack {
                Color(uiColor: UIColor.systemBackground)
                    .ignoresSafeArea()
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
                    Image(systemSymbol: .plus)
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
                        .outerShaddow()
                        .frame(height: ViewConstants.Filter.height)
                }
                Image(uiImage: category.image)
                    .fit(height: ViewConstants.Filter.imageHeight, foregroundColor: Color.gray)
            }
        }.padding(.vertical)
    }

    @ViewBuilder func pinItem(_ pin: PinModel) -> some View {
        Button {
            viewModel.selectedPin = pin
            withAnimation(.default) {
                viewModel.showPinDetail = true
            }
        } label: {
            HStack {
                if let image = pin.category.image {
                    Image(uiImage: image)
                        .fit(width: ViewConstants.PinItem.size,
                             height: ViewConstants.PinItem.size,
                             foregroundColor: XCAsset.Colors.black.swiftUIColor)
                }
                Text(pin.name.capitalized)
                    .foregroundColor(XCAsset.Colors.text.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemSymbol: .chevronForward)
                    .foregroundColor(Color.gray)
            }
        }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                pinService.deletePin(pin)
            } label: {
                Image(systemSymbol: .trash)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                NotificationConstants.showPinOnMap.post(object: pin)
            } label: {
                Image(systemSymbol: .map)
            }.tint(.blue)
        }
    }
}

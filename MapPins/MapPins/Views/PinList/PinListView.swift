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
    @StateObject var viewModel: PinListViewModel
    @ObservedObject var pinService: PinService
    @ObservedObject var preferencesService: PreferenceService

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
            }.firstLetterSectionIndex(proxy: proxy, sections: viewModel.content.keys.sorted(by: { $0 < $1 }))
            .emptyListView(displayEmptyList: viewModel.content.isEmpty, emptyListView: {
                Text(L10n.General.noResult)
                    .foregroundColor(Color(uiColor: UIColor.systemGray2))
                    .font(.system(size: 28.0))
            })
        }.task {
            viewModel.updateContent(pins: pinService.pins.responseArray ?? [], filterText: viewModel.search)
        }
        .onReceive(pinService.$pins, perform: { pins in
            viewModel.updateContent(pins: pinService.pins.responseArray ?? [], filterText: viewModel.search)
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
            preferencesService.updateFilter(category: category, add: !isOn)
            viewModel.updateContent(pins: pinService.pins.responseArray ?? [], filterText: viewModel.search)
        } label: {
            ZStack {
                if isOn {
                    Circle()
                        .fill(Color.Neumorphic.main)
                        .clipShape(Circle())
                        .softInnerShadow(Circle())
                        .frame(height: 48)
                } else {
                    Circle()
                        .fill(Color.Neumorphic.main)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.7), radius: 5, x: -3, y: -3)
                        .frame(height: 48)
                }
                if let image = category.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(height: 24)
                }
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
                        .frame(height: 24)
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

@MainActor
class PinListViewModel: ObservableObject {
    let engine: Engine

    @Published var content: [String: [PinModel]] = [:]
    @Published var showPinDetail: Bool = false
    @Published var selectedPin: PinModel?
    @Published var search = ""

    init(engine: Engine) {
        self.engine = engine
    }

    func updateContent(pins: [PinModel], filterText: String?) {
        content.removeAll()
        var pins = pins.sorted(by: { $0.name.uppercased() < $1.name.uppercased() })
        if let filterText = filterText, !filterText.isEmpty {
            pins = pins.filter({ $0.name.lowercased().contains(filterText.lowercased()) })
        }
        pins = pins.filter(({ engine.preferenceService.isCategoryOn($0.category) }))

        for pin in pins {
            let index = pin.name.first?.uppercased() ?? " "
            if !content.keys.contains(index) {
                content[index] = [pin]
            } else {
                content[index]?.append(pin)
            }
        }
    }
}

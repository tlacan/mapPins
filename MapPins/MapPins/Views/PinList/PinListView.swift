//
//  PinListView.swift
//  MapPins
//
//  Created by thomas lacan on 05/02/2023.
//

import SwiftUI

struct PinListView: View {
    let engine: Engine
    @StateObject var viewModel: PinListViewModel
    @ObservedObject var pinService: PinService

    init(engine: Engine) {
        self.engine = engine
        _viewModel = StateObject(wrappedValue: PinListViewModel())
        _pinService = ObservedObject(wrappedValue: engine.pinService)
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(viewModel.content.keys.sorted(by: { $0 < $1 }), id: \.self) { letter in
                    Section(letter) {
                        ForEach(viewModel.content[letter] ?? []) { pin in
                            pinItem(pin)
                        }
                    }.id(letter)
                }

            }.firstLetterSectionIndex(proxy: proxy, sections: viewModel.content.keys.sorted(by: { $0 < $1 }))
        }.task {
            viewModel.updateContent(pinService.pins.responseArray ?? [])
        }
        .onReceive(pinService.$pins, perform: { pins in
            viewModel.updateContent(pinService.pins.responseArray ?? [])
        })
    }

    @ViewBuilder func pinItem(_ pin: PinModel) -> some View {
        HStack {
            if let image = pin.category.image {
                Image(uiImage: image)
            }
            Text(pin.name.capitalized)
        }.swipeActions {
            Button("Burn") {
            }
            .tint(.red)
        }
    }
}

class PinListViewModel: ObservableObject {
    @Published var content: [String: [PinModel]] = [:]

    func updateContent(_ pins: [PinModel]) {
        content.removeAll()
        for pin in pins.sorted(by: { $0.name.uppercased() < $1.name.uppercased() }) {
            let index = pin.name.first?.uppercased() ?? " "
            if !content.keys.contains(index) {
                content[index] = [pin]
            } else {
                content[index]?.append(pin)
            }
        }
    }
}

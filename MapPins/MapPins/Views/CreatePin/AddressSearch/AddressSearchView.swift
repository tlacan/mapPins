//
//  AddressSearchView.swift
//  MapPins
//
//  Created by thomas lacan on 26/01/2023.
//

import SwiftUI
import Introspect

struct AddressSearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddressSearchViewModel
    @State var initialized: Bool = false

    var didPickAddress: (AddressAutocompleteModel) -> Void

    init(didPickAddress: @escaping (AddressAutocompleteModel) -> Void) {
        _viewModel = StateObject(wrappedValue: AddressSearchViewModel())
        self.didPickAddress = didPickAddress
    }

    var body: some View {
        List {
            ForEach(viewModel.address) { address in
                Button(action: {
                    didPickAddress(address)
                }) {
                    VStack(alignment: .leading) {
                        Text(address.title)
                        Text(address.subtitle)
                            .font(.caption)
                    }
                }
            }
        }
        .listStyle(.plain)
        .emptyListView(displayEmptyList: viewModel.address.isEmpty, emptyListView: {
            Text(L10n.General.noResult)
                .foregroundColor(Color(uiColor: UIColor.systemGray2))
                .font(.system(size: 28.0))
        })
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                BackButton {
                    dismiss()
                }
            }
            ToolbarItem(placement: .principal) {
                L10n.Search.title.swiftUITitle()
            }
        }
        .navigationBarBackButtonHidden()
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: L10n.Search.placeholder)
        .autocorrectionDisabled()
        .introspectTextField(customize: { textField in
            if !initialized {
                textField.becomeFirstResponder()
            }
        })
        .onReceive(viewModel.$search.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) {
            viewModel.searchAddress($0)
        }
    }
}

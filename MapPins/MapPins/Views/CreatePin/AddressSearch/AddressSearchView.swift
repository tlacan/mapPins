//
//  AddressSearchView.swift
//  MapPins
//
//  Created by thomas lacan on 26/01/2023.
//

import SwiftUI
import Introspect
import MapKit

struct AddressSearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddressSearchViewModel
    @State var initialized: Bool = false
    @State var displayGeocoderError: Bool = false
    var didPickAddress: (AddressAutocompleteModel) -> Void

    init(didPickAddress: @escaping (AddressAutocompleteModel) -> Void) {
        _viewModel = StateObject(wrappedValue: AddressSearchViewModel())
        self.didPickAddress = didPickAddress
    }

    var body: some View {
        List {
            ForEach(viewModel.address) { address in
                Button(action: {
                    addressSelected(address)
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
        .alert(L10n.Error.geocodeAddress, isPresented: $displayGeocoderError) {
            Button(L10n.General.ok, role: .cancel) { }
        }
    }

    func addressSelected(_ address: AddressAutocompleteModel) {
        Task {
            let geoCoder = CLGeocoder()
            let location = try? await geoCoder.geocodeAddressString("\(address.title) \(address.subtitle)")
            if let coordinate = location?.first?.location?.coordinate {
                var addressResult = address
                addressResult.latitude = coordinate.latitude
                addressResult.longitude = coordinate.longitude
                didPickAddress(addressResult)
                return
            }
            withAnimation(.default) {
                displayGeocoderError = true
            }
        }
    }
}

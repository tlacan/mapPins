//
//  AddressSearchViewModel.swift
//  MapPins
//
//  Created by thomas lacan on 26/01/2023.
//

import Foundation
import MapKit

class AddressSearchViewModel: NSObject, ObservableObject {
    @Published private(set) var address: [AddressAutocompleteModel] = []
    @Published var search = ""

    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()

    func searchAddress(_ text: String) {
        if text.isEmpty {
            return
        }
        searchCompleter.queryFragment = text
    }
}

extension AddressSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            address = completer.results.map {
                return AddressAutocompleteModel(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("[AddressSearchViewModel] didFailWithError \(error)")
    }
}

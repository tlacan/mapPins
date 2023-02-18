//
//  PreferencesService.swift
//  MapPins
//
//  Created by thomas lacan on 08/02/2023.
//

import Foundation
import MapKit

class PreferenceService: ObservableObject {
    @Published var filters: [PinCategory] {
        didSet {
            UserDefaults.standard.set(filters.map({ $0.rawValue }), forKey: UserDefaultsKeys.filters.rawValue)
        }
    }
    @Published var colors: [String: String] {
        didSet {
            UserDefaults.standard.set(colors, forKey: UserDefaultsKeys.colors.rawValue)
        }
    }
    @Published var transportMode: MKDirectionsTransportType {
        didSet {
            UserDefaults.standard.set(transportMode.rawValue, forKey: UserDefaultsKeys.transportMode.rawValue)
        }
    }

    init() {
        filters = (UserDefaults.standard.array(forKey: UserDefaultsKeys.filters.rawValue) as? [String] ?? []).compactMap({ PinCategory(rawValue: $0) })
        colors = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.colors.rawValue) as? [String: String] ?? [:]
        guard let storedTransportMode = UserDefaults.standard.value(forKey: UserDefaultsKeys.transportMode.rawValue) as? UInt else {
            transportMode = .walking
            return
        }
        transportMode = MKDirectionsTransportType(rawValue: storedTransportMode)
    }

    var noActiveFilters: Bool {
        filters.isEmpty || filters.count == PinCategory.allCases.count
    }

    func isCategoryOn(_ category: PinCategory) -> Bool {
        filters.isEmpty || filters.contains(where: { $0 == category })
    }

    func updateFilter(category: PinCategory, add: Bool) {
        if add {
            filters.appendIfNotContains(category)
            return
        }
        if filters.isEmpty {
            filters = PinCategory.allCases.filter({ $0 != category })
            return
        }
        filters.removeElement(category)
    }

    func filterPins(filters: [PinCategory], pins: [PinModel]) -> [PinModel] {
        if filters.isEmpty {
            return pins
        }
        return pins.filter({ pin in filters.contains { category in pin.category == category } })
    }
}

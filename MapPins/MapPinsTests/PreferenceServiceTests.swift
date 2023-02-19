//
//  PreferenceServiceTests.swift
//  MapPinsTests
//
//  Created by thomas lacan on 19/02/2023.
//

import XCTest
@testable import MapPins

final class PreferenceServiceTests: XCTestCase {

    func testNoActiveFilters() {
        let preferenceService = PreferenceService()
        preferenceService.filters.removeAll()
        XCTAssertTrue(preferenceService.noActiveFilters)
        preferenceService.filters = PinCategory.allCases
        XCTAssertTrue(preferenceService.noActiveFilters)
        preferenceService.filters.removeFirst()
        XCTAssertFalse(preferenceService.noActiveFilters)
    }

    func testIsCategoryOn() {
        let preferenceService = PreferenceService()
        preferenceService.filters.removeAll()
        XCTAssertTrue(preferenceService.isCategoryOn(.accomodation))
        preferenceService.filters = PinCategory.allCases
        XCTAssertTrue(preferenceService.isCategoryOn(.accomodation))
        preferenceService.filters.removeAll(where: { $0 == .accomodation })
        XCTAssertFalse(preferenceService.isCategoryOn(.accomodation))
    }

    func testUpdateFilter() {
        let preferenceService = PreferenceService()
        preferenceService.filters.removeAll()
        preferenceService.updateFilter(category: .accomodation, add: true)
        XCTAssertEqual(preferenceService.filters, [.accomodation])
        preferenceService.updateFilter(category: .accomodation, add: false)
        XCTAssertTrue(preferenceService.filters.isEmpty)
        XCTAssertNotEqual(preferenceService.filters, [.accomodation])
        preferenceService.filters.removeAll()
        preferenceService.updateFilter(category: .accomodation, add: false)
        XCTAssertEqual(preferenceService.filters.count, 5)
        XCTAssertNil(preferenceService.filters.firstIndex(of: .accomodation))
    }

    func testFilterPins() {
        let preferenceService = PreferenceService()
        let pins = [PinModel(name: "Pin", address: AddressAutocompleteModel(title: "address1", subtitle: "address2"), images: [], rating: 1.0, category: .accomodation)]
        XCTAssertEqual(preferenceService.filterPins(filters: [], pins: pins), pins)
        XCTAssertEqual(preferenceService.filterPins(filters: [.accomodation], pins: pins), pins)
        XCTAssertNotEqual(preferenceService.filterPins(filters: [.bakery], pins: pins), pins)
    }
}

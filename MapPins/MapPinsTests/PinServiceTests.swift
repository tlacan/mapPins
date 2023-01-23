//
//  MapPinsTests.swift
//  MapPinsTests
//
//  Created by thomas lacan on 11/01/2023.
//

import XCTest
@testable import MapPins

final class PinServiceTests: XCTestCase {
    let pinService = PinService()
    let testPin1 = PinModel(name: "Pin", latitude: 1.0, longitude: 1.0, images: [], rating: 1.0, category: .accomodation)
    let testPin2 = PinModel(name: "Pin2", latitude: 1.0, longitude: 1.0, images: [], rating: 1.0, category: .bar)

    override func tearDown() {
        super.tearDown()
        reset()
    }

    func testOperations() {
        reset()
        initTest()
        saveTest()
        updateTest()
        deleteTest()
        loadTest()
    }

    func initTest() {
        XCTAssertTrue(pinService.pins.isLoaded)
        XCTAssertNotNil(pinService.pins.responseArray)
        XCTAssertTrue(pinService.pins.responseArray?.isEmpty ?? false)
    }

    func reset() {
        pinService.pins = .init(responseArray: [])
        pinService.removeAllPins()
    }

    func saveTest() {
        initTest()
        XCTAssertNil(pinService.savePin(testPin1))
        XCTAssertTrue(pinService.pins.responseArray?.count == 1)
        XCTAssertNil(pinService.savePin(testPin2))
        XCTAssertTrue(pinService.pins.responseArray?.count == 2)
        XCTAssertTrue(pinService.pins.isLoaded)
        reset()
    }

    func updateTest() {
        initTest()
        XCTAssertNil(pinService.savePin(testPin1))
        guard var updatedPin = pinService.pins.responseArray?.first else {
            XCTFail("[PinServiceTests] test update no first value")
            return
        }
        updatedPin.category = .coffee
        XCTAssertNil(pinService.savePin(updatedPin))
        XCTAssertTrue(pinService.pins.responseArray?.count == 1)
        XCTAssertTrue(pinService.pins.responseArray?.first?.category == .coffee)
        XCTAssertTrue(pinService.pins.isLoaded)
        reset()
    }

    func deleteTest() {
        initTest()
        XCTAssertNil(pinService.savePin(testPin1))
        XCTAssertTrue(pinService.pins.responseArray?.count == 1)
        guard var pinToDelete = pinService.pins.responseArray?.first else {
            XCTFail("[PinServiceTests] test delete no first value")
            return
        }
        XCTAssertNil(pinService.deletePin(pinToDelete))
        XCTAssertTrue(pinService.pins.responseArray?.isEmpty ?? false)
        XCTAssertTrue(pinService.pins.isLoaded)
        reset()
    }

    func loadTest() {
        initTest()
        XCTAssertNil(pinService.savePin(testPin1))
        pinService.pins = .init()
        XCTAssertNil(pinService.pins.responseArray)
        XCTAssertFalse(pinService.pins.isLoaded)
        pinService.pins = pinService.loadPins()
        XCTAssertTrue(pinService.pins.isLoaded)
        XCTAssertTrue(pinService.pins.responseArray?.count == 1)
        reset()
    }
}

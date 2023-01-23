//
//  PinService.swift
//  MapPins
//
//  Created by thomas lacan on 20/01/2023.
//

import Foundation
import FileSystemStore

class PinService: ObservableObject {
    @Published var pins: LoadedData<PinModel> = LoadedData()
    private let store = MultiFileSystemStore<PinModel>(path: FileStoredData.pins.path)

    init() {
        pins = loadPins()
    }

    private func saveValues(_ values: [PinModel]) -> Error? {
        do {
            try store.save(values)
            pins = LoadedData(responseArray: values)
            return nil
        } catch let error {
            print("[PinService] store error \(error.localizedDescription)")
            return error
        }
    }

    @discardableResult
    func removeAllPins() -> Error? {
        do {
            try store.removeAll()
            return nil
        } catch let error {
            print("[PinService] remove all error \(error.localizedDescription)")
            return error
        }
    }

    func loadPins() -> LoadedData<PinModel> {
        LoadedData(responseArray: store.allObjects())
    }

    @discardableResult
    func savePin(_ pin: PinModel) -> Error? {
        // remove existing value in values if needed
        var values = (pins.responseArray ?? []).filter({ $0.id != pin.id })
        values.append(pin)
        return saveValues(values)
    }

    @discardableResult
    func deletePin(_ pin: PinModel) -> Error? {
        let values = (pins.responseArray ?? []).filter({ $0.id != pin.id })
        return saveValues(values)
    }
}

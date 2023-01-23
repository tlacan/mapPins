//
//  LoadedData.swift
//  MapPins
//
//  Created by thomas lacan on 20/01/2023.
//

import Foundation

public struct LoadedData<T> where T: Codable {
    private let loading: Bool
    public let error: Error?
    public let responseArray: [T]?
    public let responseObject: T?

    enum Status {
        case idle
        case loading
        case loaded(result: Any)
        case error(Error)
    }

    public init(loading: Bool = false) {
        self.loading = loading
        self.responseArray = nil
        self.responseObject = nil
        self.error = nil
    }

    public init(error: Error?) {
        self.error = error
        self.responseArray = nil
        self.responseObject = nil
        self.loading = false
    }

    public init(responseArray: [T]?) {
        self.error = nil
        self.responseArray = responseArray
        self.responseObject = nil
        self.loading = false
    }

    public init(responseObject: T?) {
        self.error = nil
        self.responseArray = nil
        self.responseObject = responseObject
        self.loading = false
    }

    var status: Status {
        if loading {
            return .loading
        }
        if let error = error {
            return .error(error)
        }
        if let responseArray = responseArray {
            return .loaded(result: responseArray)
        }
        if let responseObject = responseObject {
            return .loaded(result: responseObject)
        }
        return .idle
    }

    var isLoaded: Bool {
        switch status {
        case .idle, .error, .loading: return false
        case .loaded: return true
        }
    }
}

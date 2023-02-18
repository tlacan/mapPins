//
//  Notifications.swift
//  MapPins
//
//  Created by thomas lacan on 17/02/2023.
//

import Foundation

enum NotificationConstants: String {
    case showPinOnMap

    var notification: Notification.Name {
        Notification.Name(rawValue: self.rawValue)
    }

    var publisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: notification)
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: self.notification, object: object)
    }
}

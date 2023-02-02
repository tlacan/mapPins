//
//  ContentView.swift
//  MapPins
//
//  Created by thomas lacan on 11/01/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(UserDefaultsKeys.onboardingCompleted.rawValue) var onboardingCompleted: Bool = false
    let engine: Engine

    var body: some View {
        ZStack {
            //if onboardingCompleted {
                //PinMapView(engine: engine)
                CreateEditPinView(engine: engine)
                //AddressSearchView(didPickAddress: { _ in })
            //        .frame(maxWidth: .infinity, maxHeight: .infinity)
            //} else {
                //OnboardingIntroView()
                //    .frame(maxWidth: .infinity, maxHeight: .infinity)
           // }
        }
    }
}

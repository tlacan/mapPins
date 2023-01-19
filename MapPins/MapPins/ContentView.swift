//
//  ContentView.swift
//  MapPins
//
//  Created by thomas lacan on 11/01/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(UserDefaultsKeys.onboardingCompleted.rawValue) var onboardingCompleted: Bool = false

    var body: some View {
        ZStack {
            if onboardingCompleted {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Hello, world!")
                }
            } else {
                OnboardingIntroView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

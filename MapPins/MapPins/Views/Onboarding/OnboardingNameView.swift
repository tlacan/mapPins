//
//  OnboardingNameView.swift
//  MapPins
//
//  Created by thomas lacan on 18/01/2023.
//

import SwiftUI

struct OnboardingNameView: View {
    @AppStorage(UserDefaultsKeys.onboardingCompleted.rawValue) var onboardingCompleted: Bool = false
    @AppStorage(UserDefaultsKeys.name.rawValue) var name: String = ""

    var body: some View {
        VStack {
            VStack {
                LottieView(animation: Lottie.people, loop: true)
                    .frame(maxHeight: 380)
                VStack {
                    L10n.Onboarding.Name.title.swiftUITitle()
                    L10n.Onboarding.Name.description.swiftUIDescription()
                    TextField(L10n.Onboarding.Name.placeholder, text: $name)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: UIProperties.TextSize.description.rawValue))
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.givenName)
                        .disableAutocorrection(true)
                }.padding(.horizontal)
            }.frame(maxHeight: .infinity)
            ButtonView(text: L10n.General.ok, action: {
                onboardingCompleted = true
            })
                .disabled(name.isEmpty)
                .opacity(name.isEmpty ? UIProperties.Opacity.disabled.rawValue : UIProperties.Opacity.enabled.rawValue)
        }.navigationBarHidden(true)
    }
}

struct OnboardingNameView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNameView()
    }
}

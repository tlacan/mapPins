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

    struct ViewConstants {
        static let lottieMaxHeight: CGFloat = 380
    }

    var body: some View {
        VStack {
            VStack {
                LottieView(animation: Lottie.people, loop: true)
                    .frame(maxHeight: ViewConstants.lottieMaxHeight)
                VStack {
                    L10n.Onboarding.Name.title.swiftUITitle()
                    L10n.Onboarding.Name.description.swiftUIDescription()
                    TextField(L10n.Onboarding.Name.placeholder, text: $name)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: AppConstants.TextSize.description.rawValue))
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.givenName)
                        .autocorrectionDisabled()
                }.padding(.horizontal)
            }.frame(maxHeight: .infinity)
            ButtonView(text: L10n.General.ok, action: {
                onboardingCompleted = true
            })
                .disabled(name.isEmpty)
                .opacity(name.isEmpty ? AppConstants.Opacity.disabled.rawValue : AppConstants.Opacity.enabled.rawValue)
                .padding(.bottom, AppConstants.Padding.medium.rawValue)
        }.navigationBarHidden(true)
    }
}

struct OnboardingNameView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNameView()
    }
}

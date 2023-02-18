//
//  OnboardingIntroViewStep.swift
//  MapPins
//
//  Created by thomas lacan on 19/01/2023.
//

import Foundation
import Lottie

struct OnboardingIntroViewStep {
    let text: String
    let lottie: LottieAnimation
    let lottieDark: LottieAnimation?
    let action: String
    let subtitle: String

    static let steps: [OnboardingIntroViewStep] = [
        OnboardingIntroViewStep(text: L10n.Intro.Step1.description, lottie: Lottie.map, lottieDark: nil, action: L10n.General.next, subtitle: L10n.Intro.Step1.subtitle),
        OnboardingIntroViewStep(text: L10n.Intro.Step2.description, lottie: Lottie.rating, lottieDark: nil, action: L10n.General.next, subtitle: L10n.Intro.Step1.subtitle),
        OnboardingIntroViewStep(text: L10n.Intro.Step3.description, lottie: Lottie.yummy, lottieDark: Lottie.yummyDark, action: L10n.Intro.Step3.action, subtitle: L10n.Intro.Step1.subtitle)
    ]
}

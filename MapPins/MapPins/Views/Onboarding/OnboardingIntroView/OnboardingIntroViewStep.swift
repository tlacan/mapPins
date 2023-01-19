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
    let action: String
    let subtitle: String

    static var steps: [OnboardingIntroViewStep] = [
        OnboardingIntroViewStep(text: L10n.Intro.Step1.description, lottie: Lottie.map, action: L10n.General.next, subtitle: L10n.Intro.Step1.subtitle),
        OnboardingIntroViewStep(text: L10n.Intro.Step2.description, lottie: Lottie.rating, action: L10n.General.next, subtitle: L10n.Intro.Step1.subtitle),
        OnboardingIntroViewStep(text: L10n.Intro.Step3.description, lottie: Lottie.yummy, action: L10n.Intro.Step3.action, subtitle: L10n.Intro.Step1.subtitle)
    ]
}

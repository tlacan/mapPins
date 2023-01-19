//
//  OnboardingIntroView.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import SwiftUI
import Lottie

struct OnboardingIntroView: View {
    @State var showNameScreen: Bool = false
    @State var index: Int = 0

    let steps = OnboardingIntroViewStep.steps

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    VStack {
                        Spacer()
                        L10n.Intro.title.swiftUITitle()
                        Spacer()
                        TabView(selection: $index.animation()) {
                            ForEach(0..<steps.count, id: \.self) { pageIndex in
                                onboardingIntroViewStepView(steps[pageIndex])
                                    .tag(pageIndex)
                            }
                        }.tabViewStyle(.page(indexDisplayMode: .never))
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.bottom, UIProperties.Padding.medium.rawValue)

                pageControl().padding(.bottom, UIProperties.Padding.medium.rawValue)
                ButtonView(text: steps[index].action, action: buttonAction())
                    .padding(.bottom, UIProperties.Padding.medium.rawValue)
            }
            .navigationDestination(isPresented: $showNameScreen, destination: {
                OnboardingNameView()
            })
        }
    }

    func buttonAction() -> () -> Void {
        {
            withAnimation(.default) {
                if index == steps.count - 1 {
                    showNameScreen = true
                    return
                }
                index += 1
            }
        }
    }

    @ViewBuilder func pageControl() -> some View {
        HStack(spacing: 12) {
            ForEach(0..<steps.count, id: \.self) { pageIndex in
                Circle()
                    .fill(index == pageIndex ? Color.black : Color.gray)
                    .frame(width: index == pageIndex ? 8 : 6,
                           height: index == pageIndex ? 8 : 6)
                    .transition(AnyTransition.opacity)
                    .id(pageIndex)
            }
        }
    }

    @ViewBuilder func onboardingIntroViewStepView(_ step: OnboardingIntroViewStep) -> some View {
        VStack(spacing: UIProperties.Padding.verySmall.rawValue) {
            LottieView(animation: step.lottie, loop: true)
            step.text.swiftUIDescription()
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            step.subtitle.swiftUISubtitle()
                .padding(.horizontal)
                .multilineTextAlignment(.center)
        }
    }
}

struct OnboardingIntroView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIntroView()
    }
}

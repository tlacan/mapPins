//
//  OnboardingIntroView.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import SwiftUI
import Lottie

struct OnboardingIntroView: View {
    @Environment(\.colorScheme) var colorScheme

    @State var showNameScreen: Bool = false
    @State var index: Int = 0

    struct ViewConstants {
        static let pageControlSelectedSize: CGFloat = 8
        static let pageControlNotSelectedSize: CGFloat = 6
        static let pageControlSpacing: CGFloat = 12
    }

    let steps = OnboardingIntroViewStep.steps

    var body: some View {
        if #available(iOS 16, *) {
            body16()
        } else {
            body15()
        }
    }

    @available(iOS 16, *)
    @ViewBuilder func body16() -> some View {
        NavigationStack {
            mainContent()
                .navigationDestination(isPresented: $showNameScreen, destination: {
                    OnboardingNameView()
                })
        }
    }

    @ViewBuilder func body15() -> some View {
        NavigationView {
            VStack {
                NavigationLink(isActive: $showNameScreen, destination: {
                    OnboardingNameView()
                }) { EmptyView() }

                mainContent()
            }
        }
    }

    @ViewBuilder func mainContent() -> some View {
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
                .padding(.bottom, AppConstants.Padding.medium.rawValue)

            pageControl().padding(.bottom, AppConstants.Padding.medium.rawValue)
            ButtonView(text: steps[index].action, action: buttonAction())
                .padding(.bottom, AppConstants.Padding.medium.rawValue)
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
        HStack(spacing: ViewConstants.pageControlSpacing) {
            ForEach(0..<steps.count, id: \.self) { pageIndex in
                Circle()
                    .fill(index == pageIndex ? XCAsset.Colors.black.swiftUIColor : Color.gray)
                    .frame(width: index == pageIndex ? ViewConstants.pageControlSelectedSize : ViewConstants.pageControlNotSelectedSize,
                           height: index == pageIndex ? ViewConstants.pageControlSelectedSize : ViewConstants.pageControlNotSelectedSize)
                    .transition(AnyTransition.opacity)
                    .id(pageIndex)
            }
        }
    }

    @ViewBuilder func onboardingIntroViewStepView(_ step: OnboardingIntroViewStep) -> some View {
        VStack(spacing: AppConstants.Padding.verySmall.rawValue) {
            LottieView(animation: colorScheme == .dark ? (step.lottieDark ?? step.lottie) : step.lottie, loop: true)
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

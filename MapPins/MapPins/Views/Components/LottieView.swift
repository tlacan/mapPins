//
//  LottieView.swift
//  MapPins
//
//  Created by thomas lacan on 17/01/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationView = LottieAnimationView()
    let animation: LottieAnimation
    let speed: Double
    let loop: Bool

    init(animation: LottieAnimation, speed: Double = 1.0, loop: Bool = false) {
        self.animation = animation
        self.speed = speed
        self.loop = loop
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: CGRect.null)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loop ? .loop : .playOnce
        animationView.backgroundColor = .clear
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = speed
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        animationView.play()
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}

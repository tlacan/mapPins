//
//  TouchEnterExit.swift
//  MapPins
//
//  Created by thomas lacan on 05/02/2023.
//

import SwiftUI

struct TouchEnterExit: ViewModifier {
    @GestureState var dragLocation: CGPoint = .zero
    @State var didEnter = false

    let onEnter: (() -> Void)?
    let onExit: (() -> Void)?

    func body(content: Content) -> some View {
        content.gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
          .background(GeometryReader { geo in
              dragObserver(geo)
          })
    }

    func dragObserver(_ geo: GeometryProxy) -> some View {
        if geo.frame(in: .global).contains(dragLocation) {
            Task { @MainActor in
                didEnter = true
                onEnter?()
            }
        } else if didEnter {
            Task { @MainActor in
                didEnter = false
                onExit?()
            }
        }
        return Color.clear
    }
}

extension View {
    func touchEnterExit(onEnter: (() -> Void)? = nil,
                      onExit: (() -> Void)? = nil) -> some View {
        self.modifier(TouchEnterExit(onEnter: onEnter, onExit: onExit))
    }
}

class TouchEnterExitProxy<ID: Hashable> {
    let onEnter: ((ID) -> Void)?
    let onExit: ((ID) -> Void)?

    private var frames = [ID: CGRect]()
    private var didEnter = [ID: Bool]()

    init(onEnter: ((ID) -> Void)?, onExit: ((ID) -> Void)?) {
        self.onEnter = onEnter
        self.onExit = onExit
    }

    func register(id: ID, frame: CGRect) {
        frames[id] = frame
        didEnter[id] = false
    }

    func check(dragPosition: CGPoint) {
        for (id, frame) in frames {
            if frame.contains(dragPosition) {
                Task { @MainActor in
                    didEnter[id] = true
                    onEnter?(id)
                }
            } else if didEnter[id] == true {
                Task { @MainActor in
                    didEnter[id] = false
                    onExit?(id)
                }
            }
        }
    }
}

struct TouchEnterExitReader<ID, Content>: View where ID: Hashable, Content: View {
    private let proxy: TouchEnterExitProxy<ID>
    private let content: (TouchEnterExitProxy<ID>) -> Content

    init(_ idSelf: ID.Type, // without this, the initializer can't infer ID type
         onEnter: ((ID) -> Void)? = nil,
         onExit: ((ID) -> Void)? = nil,
         @ViewBuilder content: @escaping (TouchEnterExitProxy<ID>) -> Content) {
        proxy = TouchEnterExitProxy(onEnter: onEnter, onExit: onExit)
        self.content = content
    }

    var body: some View {
        content(proxy)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onChanged { value in
                        proxy.check(dragPosition: value.location)
                    })
    }
}

struct GroupTouchEnterExit<ID>: ViewModifier where ID: Hashable {
    let id: ID
    let proxy: TouchEnterExitProxy<ID>

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geo in
                dragObserver(geo)
            })
    }

    private func dragObserver(_ geo: GeometryProxy) -> some View {
        proxy.register(id: id, frame: geo.frame(in: .global))
        return Color.clear
    }
}

extension View {
    func touchEnterExit<ID: Hashable>(id: ID, proxy: TouchEnterExitProxy<ID>) -> some View {
        self.modifier(GroupTouchEnterExit(id: id, proxy: proxy))
    }
}

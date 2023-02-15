//
//  SettingsScreen.swift
//  MapPins
//
//  Created by thomas lacan on 13/02/2023.
//

import SwiftUI
import AckGenUI

struct SettingsScreen: View {
    @State var showAcknowledgement: Bool = false

    var body: some View {
        if #available(iOS 16.0, *) {
            body16()
        } else {
            body15()
        }
    }

    @available(iOS 16.0, *)
    @ViewBuilder func body16() -> some View {
        NavigationStack {
            mainContent()
        }
    }

    @ViewBuilder func body15() -> some View {
        NavigationView {
            ZStack {
                NavigationLink(isActive: $showAcknowledgement) {
                    AcknowledgementsList()
                } label: {
                    EmptyView()
                }
                mainContent()
            }
        }
    }

    @ViewBuilder func mainContent() -> some View {
        List {
            NavigationLink {
                AcknowledgementsList()
            } label: {
                Text("Acknowledgements")
            }

        }.navigationTitle(L10n.Tab.Settings.title)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}

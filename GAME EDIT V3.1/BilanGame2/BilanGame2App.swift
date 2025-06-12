//
//  BilanGame2App.swift
//  BilanGame2
//
//  Created by Joel Lewis on 18/03/2025.
//


import SwiftUI
import RealityKitContent

@main
struct BilanGame2App: App {
    @State private var appModel = AppModel()
    @State private var tracker = SphereTracker()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .environmentObject(tracker)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .environmentObject(tracker)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}

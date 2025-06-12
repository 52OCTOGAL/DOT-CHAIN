//
//  SettingsTab.swift
//  BilanGame2
//
//  Created by Awo-Bilan Dahir  on 03/06/2025.
//


//
//  SettingsTab.swift
//  BilanGame2
//

import SwiftUI

struct SettingsTab: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack(spacing: 30) {
            Text("Settings")
                .font(.title2)
                .padding(.top)

            VStack(spacing: 16) {
                Text("Difficulty")
                    .font(.headline)

                Picker("Difficulty", selection: Binding(
                    get: {
                        GameDifficulty.allCases.first { $0.sphereCount == appModel.numberOfSpheres } ?? .medium
                    },
                    set: { appModel.setDifficulty($0) }
                )) {
                    ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.description).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(spacing: 16) {
                Text("Custom Sphere Count")
                    .font(.headline)

                Stepper("Spheres: \(appModel.numberOfSpheres)", value: Binding(
                    get: { appModel.numberOfSpheres },
                    set: { appModel.setNumberOfSpheres($0) }
                ), in: 1...20)
                .padding(.horizontal)
            }

            Button("Reset Game") {
                appModel.resetGame()
            }
            .buttonStyle(CapsuleButtonStyle(background: .brandAccent, foreground: .black))

            Spacer()
        }
        .padding()
        .frame(maxWidth: 500)
    }
}

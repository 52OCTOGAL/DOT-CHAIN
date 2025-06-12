//
//  LevelSelectTab.swift
//  BilanGame2
//

import SwiftUI
import RealityKitContent

struct LevelSelectTab: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        VStack(spacing: 24) {
            Text("Select a Level")
                .font(.title2)
                .padding(.top)

            ForEach(GameDifficulty.allCases, id: \.self) { level in
                Button(action: {
                    appModel.setDifficulty(level)
                    appModel.resetGame()
                }) {
                    Text(level.description)
                }
                .buttonStyle(CapsuleButtonStyle(background: .brandPrimary))
            }

            Spacer()

            Button {
                Task {
                    await openImmersiveSpace(id: appModel.immersiveSpaceID)
                }
            } label: {
                Label("Show Dots", systemImage: "cube.transparent")
            }
            .buttonStyle(CapsuleButtonStyle(background: .brandAccent, foreground: .black))
            .padding(.bottom)
        }
        .padding()
        .frame(maxWidth: 500)
    }
}

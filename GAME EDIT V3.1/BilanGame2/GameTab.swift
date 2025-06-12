
//
//  GameTab.swift
//  BilanGame2
//

import SwiftUI

struct GameTab: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack(spacing: 20) {
            ToggleImmersiveSpaceButton()

            Text("Current Target: \(appModel.currentTarget)")
                .font(.largeTitle)

            ProgressView(value: appModel.gameProgress)
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(y: 2)

            if appModel.consecutiveCorrect > 0 {
                Text("Streak: \(appModel.consecutiveCorrect)")
                    .foregroundColor(.green)
            }

            if appModel.gameCompleted {
                VStack(spacing: 12) {
                    Text("🎉 You finished!")
                        .font(.title)
                        .foregroundColor(.green)

                    Text(String(format: "Time: %.1f sec", appModel.elapsedTime))

                    if let best = appModel.bestTime {
                        Text(String(format: "Best: %.1f sec", best))
                            .foregroundColor(.blue)
                    }

                    Button("Play Again") {
                        appModel.resetGame()
                    }
                    .buttonStyle(CapsuleButtonStyle(background: .brandPrimary))

                    Button("Show Tutorial") {
                        appModel.resetTutorial()
                    }
                    .buttonStyle(CapsuleButtonStyle(background: .brandAccent, foreground: .black))
                }
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: 500) // ✅ Reduce width to eliminate dead space
    }
}

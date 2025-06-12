//
//  StatsTab.swift
//  BilanGame2
//
//  Created by Awo-Bilan Dahir  on 12/06/2025.
//


//
//  StatsTab.swift
//  BilanGame2
//

import SwiftUI

struct StatsTab: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Stats")
                .font(.title2)
                .padding(.top)

            if appModel.elapsedTime > 0 {
                Text(String(format: "Last Time: %.1f sec", appModel.elapsedTime))
                    .font(.headline)
            }

            if let best = appModel.bestTime {
                Text(String(format: "Best Time: %.1f sec", best))
                    .font(.headline)
                    .foregroundColor(.blue)
            } else {
                Text("No best time recorded yet.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button("Reset High Score") {
                appModel.clearBestTime()
            }
            .buttonStyle(CapsuleButtonStyle(background: .brandAccent, foreground: .black))
        }
        .padding()
        .frame(maxWidth: 500)
    }
}


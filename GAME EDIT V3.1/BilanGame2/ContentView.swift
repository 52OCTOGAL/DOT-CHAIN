//
//  ContentView.swift
//  BilanGame2
//
//  Created by Joel Lewis on 18/03/2025.
//
import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        Group {
            if appModel.showTutorial {
                TutorialView()
            } else {
                gameView
            }
        }
    }
    
    @ViewBuilder
    private var gameView: some View {
        VStack(spacing: 20) {
            ToggleImmersiveSpaceButton()
            
            // Game Configuration Section
            VStack(spacing: 12) {
                Text("Game Settings")
                    .font(.headline)
                
                // Difficulty Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Difficulty:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
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
                
                // Custom sphere count option
                VStack(alignment: .leading, spacing: 8) {
                    Text("Or set custom count:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Spheres: \(appModel.numberOfSpheres)")
                        Spacer()
                        Stepper(
                            value: Binding(
                                get: { appModel.numberOfSpheres },
                                set: { appModel.setNumberOfSpheres($0) }
                            ),
                            in: 1...20
                        ) {
                            Text("Spheres")
                        }
                        .labelsHidden()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            Divider()
            
            // Game Status Section
            VStack(spacing: 12) {
                Text("Find and pinch spheres 1-\(appModel.numberOfSpheres) in order")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("Current target: \(appModel.currentTarget)")
                    .font(.title)
                    .foregroundColor(.primary)
                
                // Progress bar
                ProgressView(value: appModel.gameProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .scaleEffect(y: 2)
                
                Text("Progress: \(appModel.currentTarget - 1)/\(appModel.numberOfSpheres)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if appModel.consecutiveCorrect > 0 {
                    Text("Streak: \(appModel.consecutiveCorrect)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
            
            if appModel.gameCompleted {
                VStack(spacing: 12) {
                    Text("🎉 Congratulations! 🎉")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Text("You completed the sequence of \(appModel.numberOfSpheres) spheres!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Button("Play Again") {
                        appModel.resetGame()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    // Show tutorial again option
                    Button("Show Tutorial") {
                        appModel.resetTutorial()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}


#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

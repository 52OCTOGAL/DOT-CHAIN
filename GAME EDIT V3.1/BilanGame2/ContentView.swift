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
        VStack {
            ToggleImmersiveSpaceButton()
            
            Text("Find and pinch spheres 1-5 in order")
                .font(.headline)
                .padding()
            
            Text("Current target: \(appModel.currentTarget)")
                .font(.title)
                .padding()
            
            if appModel.gameCompleted {
                Text("Congratulations! You completed the sequence!")
                    .font(.title)
                    .foregroundColor(.green)
                    .padding()
                
                Button("Play Again") {
                    appModel.resetGame()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

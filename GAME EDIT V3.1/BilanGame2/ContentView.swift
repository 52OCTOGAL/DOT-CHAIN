//
//  ContentView.swift
//  BilanGame2
//

import SwiftUI

struct ContentView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        Group {
            if appModel.showTutorial {
                TutorialView()
            } else {
                MainTabView()
            }
        }
        .frame(maxWidth: 500) // ✅ Limit window width globally
        .onAppear {
            appModel.loadBestTimeIfNeeded()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            GameTab()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }

            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }

            LevelSelectTab()
                .tabItem {
                    Label("Levels", systemImage: "list.number")
                }

            StatsTab()
                .tabItem {
                    Label("Stats", systemImage: "timer")
                }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
        .environmentObject(SphereTracker())
}

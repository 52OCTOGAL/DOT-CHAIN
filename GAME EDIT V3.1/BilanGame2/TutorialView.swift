//
//  TutorialView.swift
//  BilanGame2
//
//  Created by Awo-Bilan Dahir  on 03/06/2025.
//


import SwiftUI

struct TutorialView: View {
    @Environment(AppModel.self) private var appModel
    @State private var currentPage = 0
    
    private let totalPages = 4
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Tutorial")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Skip") {
                    appModel.completeTutorial()
                }
                .foregroundColor(.blue)
            }
            .padding()
            
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .padding(.bottom)
            
            // Tutorial content
            TabView(selection: $currentPage) {
                // Page 1: Welcome
                TutorialPageView(
                    icon: "hand.wave.fill",
                    iconColor: .yellow,
                    title: "Welcome to Sphere Sequence!",
                    description: "Learn to play this fun mixed reality game where you'll interact with floating spheres in 3D space.",
                    details: [
                        "• Use your Vision Pro to see numbered spheres around you",
                        "• Tap spheres with precise hand gestures",
                        "• Challenge your memory and coordination"
                    ]
                )
                .tag(0)
                
                // Page 2: How to Play
                TutorialPageView(
                    icon: "target",
                    iconColor: .red,
                    title: "How to Play",
                    description: "The goal is simple: find and tap the numbered spheres in the correct order, starting from 1.",
                    details: [
                        "• Look around to find all the spheres",
                        "• Each sphere has a number (1, 2, 3, etc.)",
                        "• Tap them in ascending order: 1 → 2 → 3 → 4 → 5",
                        "• The current target number is shown on screen"
                    ]
                )
                .tag(1)
                
                // Page 3: Controls
                TutorialPageView(
                    icon: "hand.point.up.left.fill",
                    iconColor: .blue,
                    title: "Controls & Interaction",
                    description: "Use natural hand gestures to interact with the spheres in mixed reality.",
                    details: [
                        "• Look at a sphere to focus on it",
                        "• Use a pinch gesture to tap/select",
                        "• Spheres will disappear when tapped correctly",
                        "• Wrong selections reset your streak"
                    ]
                )
                .tag(2)
                
                // Page 4: Game Features
                TutorialPageView(
                    icon: "gamecontroller.fill",
                    iconColor: .green,
                    title: "Game Features",
                    description: "Customize your experience and track your progress as you play.",
                    details: [
                        "• Choose difficulty levels (3-10 spheres)",
                        "• Set custom sphere counts for extra challenge",
                        "• Track your progress and streak",
                        "• Play again to improve your skills"
                    ]
                )
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
            Spacer()
            
            // Navigation buttons
            HStack {
                // Previous button
                Button(action: {
                    if currentPage > 0 {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .foregroundColor(currentPage > 0 ? .blue : .gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(currentPage > 0 ? Color.blue : Color.gray, lineWidth: 1)
                    )
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                // Next/Start button
                Button(action: {
                    if currentPage < totalPages - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        appModel.completeTutorial()
                    }
                }) {
                    HStack {
                        Text(currentPage == totalPages - 1 ? "Start Game" : "Next")
                        if currentPage < totalPages - 1 {
                            Image(systemName: "chevron.right")
                        } else {
                            Image(systemName: "play.fill")
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(currentPage == totalPages - 1 ? Color.green : Color.blue)
                    )
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
}

// Individual tutorial page component
struct TutorialPageView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let details: [String]
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(iconColor)
                .padding()
                .background(
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
            
            // Title
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Description
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Details
            VStack(alignment: .leading, spacing: 8) {
                ForEach(details, id: \.self) { detail in
                    Text(detail)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TutorialView()
        .environment(AppModel())
}

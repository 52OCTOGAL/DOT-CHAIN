//
//  AppModel.swift
//  BilanGame2
//
//  Created by Joel Lewis on 18/03/2025.
//


//  AppModel.swift
//  BilanGame2

import Foundation
import SwiftUI

@MainActor
class AppModel: ObservableObject, Observable {
    @Published var showTutorial: Bool = true
    @AppStorage("bestTime") private var storedBestTime: Double?

    @Published var numberOfSpheres: Int = 10
    @Published var currentTarget: Int = 1
    @Published var consecutiveCorrect: Int = 0
    @Published var elapsedTime: Double = 0
    @Published var immersiveSpaceState: ImmersiveSpaceState = .closed

    let immersiveSpaceID = "ImmersiveSpace"

    enum ImmersiveSpaceState {
        case closed, open, inTransition
    }

    var gameCompleted: Bool {
        currentTarget > numberOfSpheres
    }

    var gameProgress: Double {
        Double(currentTarget - 1) / Double(numberOfSpheres)
    }

    var sphereNumbers: [Int] {
        Array(1...numberOfSpheres)
    }

    var bestTime: Double? {
        storedBestTime
    }

    // MARK: - Tutorial & Game Setup

    func completeTutorial() {
        showTutorial = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showTutorial = true
        }
        resetGame()
    }

    func resetTutorial() {
        showTutorial = true
    }

    func setDifficulty(_ difficulty: GameDifficulty) {
        numberOfSpheres = difficulty.sphereCount
        resetGame()
    }

    func setNumberOfSpheres(_ count: Int) {
        numberOfSpheres = count
        resetGame()
    }

    func resetGame() {
        currentTarget = 1
        consecutiveCorrect = 0
        elapsedTime = 0
        startTimer()
    }

    func advanceTarget() {
        currentTarget += 1
        consecutiveCorrect += 1

        if gameCompleted {
            stopTimer()
            if let best = bestTime {
                if elapsedTime < best {
                    storedBestTime = elapsedTime
                }
            } else {
                storedBestTime = elapsedTime
            }
        }
    }

    func incorrectSelection() {
        consecutiveCorrect = 0
    }

    func clearBestTime() {
        storedBestTime = nil
    }

    // MARK: - Timer Logic

    private var timer: Timer?
    private var startTime: Date?

    private func startTimer() {
        timer?.invalidate()
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(start)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func loadBestTimeIfNeeded() {
        _ = bestTime
    }
}

enum GameDifficulty: CaseIterable {
    case easy, medium, hard, expert

    var sphereCount: Int {
        switch self {
        case .easy: return 5
        case .medium: return 10
        case .hard: return 15
        case .expert: return 20
        }
    }

    var description: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .expert: return "Expert"
        }
    }
}

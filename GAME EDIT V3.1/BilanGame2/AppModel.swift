//
//  AppModel.swift
//  BilanGame2
//
//  Created by Joel Lewis on 18/03/2025.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    // MARK: - Game Configuration
    /// Number of spheres in the game (configurable)
    var numberOfSpheres: Int = 5 {
        didSet {
            // Reset game when number of spheres changes
            if numberOfSpheres != oldValue {
                resetGame()
            }
        }
    }
    
    // MARK: - Tutorial State
    var showTutorial = true
    var tutorialCompleted = false
    
    // MARK: - Game State
    var currentTarget = 1
    var gameCompleted = false
    var consecutiveCorrect = 0
    
    // MARK: - Computed Properties
    /// Returns the maximum target number (same as numberOfSpheres)
    var maxTarget: Int {
        return numberOfSpheres
    }
    
    /// Returns an array of sphere numbers (1 through numberOfSpheres)
    var sphereNumbers: [Int] {
        return Array(1...numberOfSpheres)
    }
    
    /// Returns progress as a percentage (0.0 to 1.0)
    var gameProgress: Double {
        guard numberOfSpheres > 0 else { return 0.0 }
        return Double(currentTarget - 1) / Double(numberOfSpheres)
    }
    
    // MARK: - Game Logic
    func advanceTarget() {
        if currentTarget < numberOfSpheres {
            currentTarget += 1
            consecutiveCorrect += 1
        } else {
            gameCompleted = true
        }
    }
    
    func incorrectSelection() {
        consecutiveCorrect = 0
    }
    
    func resetGame() {
        currentTarget = 1
        gameCompleted = false
        consecutiveCorrect = 0
    }
    
    // MARK: - Tutorial Methods
    func completeTutorial() {
        showTutorial = false
        tutorialCompleted = true
    }
    
    func resetTutorial() {
        showTutorial = true
        tutorialCompleted = false
        resetGame()
    }
    
    // MARK: - Configuration Methods
    /// Sets the number of spheres for the game (minimum 1, maximum 20 for practical reasons)
    func setNumberOfSpheres(_ count: Int) {
        let clampedCount = max(1, min(20, count))
        numberOfSpheres = clampedCount
    }
    
    /// Convenience method to set common sphere counts
    func setDifficulty(_ difficulty: GameDifficulty) {
        numberOfSpheres = difficulty.sphereCount
    }
}

// MARK: - Game Difficulty Enum
enum GameDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case expert = "Expert"
    
    var sphereCount: Int {
        switch self {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        case .expert: return 10
        }
    }
    
    var description: String {
        return "\(rawValue) (\(sphereCount) spheres)"
    }
}

//this is the logic me thinks - now with configurable sphere count!

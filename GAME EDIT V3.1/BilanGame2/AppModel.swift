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
    
    var currentTarget = 1
    var gameCompleted = false
    var consecutiveCorrect = 0
    
    func advanceTarget() {
        if currentTarget < 5 {
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
}


//this is the logic me thinks

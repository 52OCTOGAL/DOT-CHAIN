//
//  SphereTracker.swift
//  BilanGame2
//
//  Created by Awo-Bilan Dahir  on 12/06/2025.
//


import Foundation

/// Tracks removed spheres so they aren't redrawn in update
@MainActor
class SphereTracker: ObservableObject {
    private(set) var removedNumbers: Set<Int> = []

    func markRemoved(_ number: Int) {
        removedNumbers.insert(number)
    }

    func reset() {
        removedNumbers.removeAll()
    }

    func isRemoved(_ number: Int) -> Bool {
        removedNumbers.contains(number)
    }
}

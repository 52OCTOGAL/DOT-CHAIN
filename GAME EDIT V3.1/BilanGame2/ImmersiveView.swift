//
//  ImmersiveView.swift
//  BilanGame2
//
//  Created by Joel Lewis on 18/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Foundation // Add this import for cos() and sin() functions

// Custom component to identify spheres and their numbers
struct SphereComponent: Component {
    var number: Int
    
    init(number: Int) {
        self.number = number
    }
}

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    // Store references to sphere entities so we can remove them
    @State private var sphereEntities: [Int: Entity] = [:]

    var body: some View {
        // Game view with the spheres
        RealityView { content in
            // Clear existing spheres first
            sphereEntities.removeAll()
            
            // Create and add the spheres to the content
            for i in appModel.sphereNumbers {
                // Add gesture handling
                let sphereEntity = createNumberedSphere(number: i)
                
                // Use the new positioning function
                sphereEntity.position = calculateSpherePosition(for: i, total: appModel.numberOfSpheres)
                
                sphereEntity.components[SphereComponent.self] = SphereComponent(number: i)
                
                // Add sphere to content
                content.add(sphereEntity)
                
                // Store reference to the entity
                sphereEntities[i] = sphereEntity
            }
        } update: { content in
            // Handle updates when numberOfSpheres changes
            if sphereEntities.count != appModel.numberOfSpheres {
                // Remove all existing spheres
                for entity in sphereEntities.values {
                    content.remove(entity)
                }
                sphereEntities.removeAll()
                
                // Add new spheres
                for i in appModel.sphereNumbers {
                    let sphereEntity = createNumberedSphere(number: i)
                    sphereEntity.position = calculateSpherePosition(for: i, total: appModel.numberOfSpheres)
                    sphereEntity.components[SphereComponent.self] = SphereComponent(number: i)
                    content.add(sphereEntity)
                    sphereEntities[i] = sphereEntity
                }
            }
        }
        .gesture(sphereTap)
    }
    
    // Update the positioning logic to handle variable numbers of spheres
    private func calculateSpherePosition(for number: Int, total: Int) -> SIMD3<Float> {
        let angle = Double(number - 1) * (2 * Double.pi / Double(total))
        let radius: Float = 0.3
        
        // For small numbers of spheres, use a smaller radius to keep them closer
        let adjustedRadius = total <= 3 ? radius * 0.7 : radius
        
        return SIMD3<Float>(
            x: Float(cos(angle)) * adjustedRadius,
            y: 1.5 + Float(sin(angle)) * adjustedRadius,
            z: -1.0
        )
    }
    
    // 2. Create our gesture
    var sphereTap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                //print("Got a tap!")
                // Handle tap gesture
                let entity = value.entity
                if let sphereComponent = entity.components[SphereComponent.self] {
                    handleSphereSelection(entity: entity, number: sphereComponent.number)
                }
            }
    }
    
    // Handle sphere selection
    private func handleSphereSelection(entity: Entity, number: Int) {
        print("Hi! I got a tap on Sphere number: \(number), the current target is: \(appModel.currentTarget)")
        if number == appModel.currentTarget {
            // Correct selection
            appModel.advanceTarget()
            
            // Make the sphere disappear
            entity.isEnabled = false
        } else {
            // Incorrect selection
            appModel.incorrectSelection()
        }
    }
    
    // Create a sphere with a number
    private func createNumberedSphere(number: Int) -> Entity {
        let sphereEntity = Entity()
        let radius: Float = 0.06 // Reduced from 0.1 to make each sphere smaller
        
        // Create sphere mesh
        let sphereMesh = MeshResource.generateSphere(radius: radius)
        let sphereMaterial = SimpleMaterial(color: getColorForNumber(number), roughness: 0.5, isMetallic: false)
        let sphereModelEntity = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
        sphereEntity.addChild(sphereModelEntity)
        
        // Add number label as a 3D text entity
        let textAttachment = createNumberAttachment(number: number, sphereRadius: radius)
        sphereEntity.addChild(textAttachment)
        
        // Make entity interactive, gesture-able
        sphereEntity.components.set(InputTargetComponent())
        
        // Create a collision component with an empty group and mask.
        var collision = CollisionComponent(shapes: [.generateSphere(radius: radius)])
        collision.filter = CollisionFilter(group: [], mask: [])
        sphereEntity.components.set(collision)
        
        return sphereEntity
    }
    
    // Create a properly centered text attachment for the number
    private func createNumberAttachment(number: Int, sphereRadius: Float) -> Entity {
        // Text entity to hold the 3D text
        let textEntity = ModelEntity()
        
        // Create a 3D text mesh with smaller font size to match smaller spheres
        let textMesh = MeshResource.generateText(
            "\(number)",
            extrusionDepth: 0.001,
            font: .systemFont(ofSize: 0.03, weight: .bold), // Reduced from 0.05
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        
        // Create a white material for the text
        let textMaterial = SimpleMaterial(color: .white, isMetallic: false)
        
        // Apply the mesh and material to the entity
        textEntity.model = ModelComponent(mesh: textMesh, materials: [textMaterial])
        
        // Position the text at the front of the sphere
        // RealityKit's text is automatically centered at its origin point
        textEntity.position = [0, 0, sphereRadius + 0.005] // Just slightly in front of the sphere surface
        
        return textEntity
    }
    
    // Get different colors for each numbered sphere - now handles more than 5 spheres
    private func getColorForNumber(_ number: Int) -> UIColor {
        let colors: [UIColor] = [
            .systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple,
            .systemPink, .systemTeal, .systemIndigo, .systemBrown, .systemCyan,
            .systemMint, .systemYellow, .magenta, .darkGray, .lightGray,
            .systemRed.withAlphaComponent(0.7), .systemBlue.withAlphaComponent(0.7),
            .systemGreen.withAlphaComponent(0.7), .systemOrange.withAlphaComponent(0.7),
            .systemPurple.withAlphaComponent(0.7)
        ]
        
        // Use modulo to cycle through colors if we have more spheres than colors
        let colorIndex = (number - 1) % colors.count
        return colors[colorIndex]
    }
}

// i have tried so many times to like centre the numbers but at least it does dissapre when pressed
// Now with configurable sphere count and better color handling!

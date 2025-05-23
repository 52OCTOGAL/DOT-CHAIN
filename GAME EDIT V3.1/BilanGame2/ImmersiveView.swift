//
//  ImmersiveView.swift
//  BilanGame2
//
//  Created by Joel Lewis on 18/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

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
            // Create and add the spheres to the content
            for i in 1...5 {
                // Add gesture handling
                let sphereEntity = createNumberedSphere(number: i)
                
                // Position spheres in different locations
                let angle = Double(i) * (2 * Double.pi / 5)
                let radius: Float = 0.3 // Reduced from 0.5 to make the formation smaller
                sphereEntity.position = SIMD3<Float>(
                    x: Float(cos(angle)) * radius,
                    y: 1.5 + Float(sin(angle)) * radius, // Changed from 2 to 0.0 to position at eye level
                    z: -1.0 // Move spheres back in z-axis
                )
                
                sphereEntity.components[SphereComponent.self] = SphereComponent(number: i)
                
                // Add sphere to content
                content.add(sphereEntity)
                
                // Store reference to the entity
                sphereEntities[i] = sphereEntity
            }
        } update: { content in
            // Update content if needed
        }
        .gesture(sphereTap)
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
    
    // Get different colors for each numbered sphere
    private func getColorForNumber(_ number: Int) -> UIColor {
        switch number {
        case 1: return .systemRed
        case 2: return .systemBlue
        case 3: return .systemGreen
        case 4: return .systemOrange
        case 5: return .systemPurple
        default: return .white
        }
    }
}

// i have tried so many times to like centre the numbers but at least it does dissapre when pressed

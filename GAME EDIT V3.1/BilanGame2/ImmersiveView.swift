//  ImmersiveView.swift
//  BilanGame2

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation

struct SphereComponent: Component {
    var number: Int
}

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    @EnvironmentObject private var tracker: SphereTracker

    @State private var sphereEntities: [Int: Entity] = [:]

    let sphereHexColors: [String] = [
        "#D75658", "#EF9449", "#EE7E7E", "#FC8586", "#9A9BE9",
        "#EF7FBF", "#F3ED59", "#FBF45D", "#AEB9FC", "#F1A5DA",
        "#C7FDB2", "#BBEBD7", "#B5DDFB", "#FCF1B1", "#BCFDF1"
    ]

    var body: some View {
        RealityView { content in
            resetSpheresSync(in: content)
        } update: { content in
            resetSpheresSync(in: content)
        }
        .gesture(sphereTap)
    }

    private func resetSpheresSync(in content: RealityViewContent) {
        for entity in sphereEntities.values {
            content.remove(entity)
        }
        sphereEntities.removeAll()
        tracker.reset()

        for i in appModel.sphereNumbers {
            let sphereEntity = createNumberedSphere(number: i)
            sphereEntity.position = calculateSpherePosition(for: i, total: appModel.numberOfSpheres)
            sphereEntity.components.set(SphereComponent(number: i))
            content.add(sphereEntity)
            sphereEntities[i] = sphereEntity
        }
    }

    private func calculateSpherePosition(for number: Int, total: Int) -> SIMD3<Float> {
        let angle = Double(number - 1) * (2 * Double.pi / Double(total))
        let radius: Float = 0.3 + Float(total) * 0.005
        return SIMD3<Float>(
            x: Float(cos(angle)) * radius,
            y: 1.5 + Float(sin(angle)) * radius,
            z: -1.0
        )
    }

    var sphereTap: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                let entity = value.entity
                if let component = entity.components[SphereComponent.self] {
                    handleSphereSelection(entity: entity, number: component.number)
                }
            }
    }

    private func handleSphereSelection(entity: Entity, number: Int) {
        AudioServicesPlaySystemSound(1104) // tap feedback

        if number == appModel.currentTarget {
            appModel.advanceTarget()
            entity.removeFromParent()
            sphereEntities.removeValue(forKey: number)

            if appModel.gameCompleted {
                playVictoryFeedback()
            }
        } else {
            AudioServicesPlaySystemSound(1107) // error feedback
            appModel.incorrectSelection()
        }
    }

    private func playVictoryFeedback() {
        AudioServicesPlaySystemSound(1113) // success ping
    }

    private func createNumberedSphere(number: Int) -> Entity {
        let sphereEntity = Entity()
        let radius: Float = 0.06

        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: getColorForNumber(number), roughness: 0.4, isMetallic: false)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        sphereEntity.addChild(modelEntity)

        let text = createNumberAttachment(number: number, sphereRadius: radius)
        sphereEntity.addChild(text)

        sphereEntity.components.set(InputTargetComponent())
        sphereEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: radius)]))

        return sphereEntity
    }

    private func createNumberAttachment(number: Int, sphereRadius: Float) -> Entity {
        let textEntity = ModelEntity()
        let textMesh = MeshResource.generateText(
            "\(number)",
            extrusionDepth: 0.001,
            font: .systemFont(ofSize: 0.03, weight: .bold),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byTruncatingTail
        )
        let material = SimpleMaterial(color: .white, isMetallic: false)
        textEntity.model = ModelComponent(mesh: textMesh, materials: [material])
        textEntity.position = [0, 0, sphereRadius + 0.005]
        return textEntity
    }

    private func getColorForNumber(_ number: Int) -> UIColor {
        let hex = sphereHexColors[(number - 1) % sphereHexColors.count]
        return UIColor(hex: hex)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r = CGFloat((int >> 16) & 0xFF) / 255.0
        let g = CGFloat((int >> 8) & 0xFF) / 255.0
        let b = CGFloat(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

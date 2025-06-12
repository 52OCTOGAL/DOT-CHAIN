//
//  TutorialView.swift
//  BilanGame2
//
//  Created by Awo-Bilan Dahir  on 03/06/2025.
//
import SwiftUI

struct TutorialView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(radius: 10)

            Text("Welcome to Dot Chain")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)

            Text("Tap the spheres in order from 1 to \(appModel.numberOfSpheres). You can change difficulty or level anytime.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 16) {
                Button("Start Game") {
                    appModel.completeTutorial()
                }
                .buttonStyle(CapsuleButtonStyle(background: .brandPrimary))

                Button("Quit") {
                    exit(0)
                }
                .font(.callout)
                .foregroundColor(.red)
                .padding(.top, 4)
            }

            Spacer()
        }
        .padding()
    }
}

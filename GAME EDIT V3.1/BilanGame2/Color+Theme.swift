

import SwiftUI

extension Color {
    static let brandPrimary = Color(hex: "#ABB6F9")
    static let brandAccent = Color(hex: "#B5DFFC")
    static let brandBackground = Color(hex: "#FFFFFF")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

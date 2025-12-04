import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hexSanitized.count == 6 { hexSanitized.append("FF") }
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)

        let a, r, g, b: UInt64
        a = int & 0xFF
        b = (int >> 8) & 0xFF
        g = (int >> 16) & 0xFF
        r = (int >> 24) & 0xFF

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

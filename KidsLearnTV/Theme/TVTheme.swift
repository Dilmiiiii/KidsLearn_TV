import SwiftUI

enum TVTheme {
    static let background = Color(red: 0.055, green: 0.084, blue: 0.18)
    static let panel = Color(red: 0.12, green: 0.17, blue: 0.28)
    static let purple = Color(red: 0.56, green: 0.39, blue: 0.99)
    static let teal = Color(red: 0.18, green: 0.78, blue: 0.76)
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.3)
    static let pink = Color(red: 1.0, green: 0.42, blue: 0.6)
    static func accent(for category: LearningCategory) -> Color {
        switch category { case .abc: return purple; case .numbers: return teal; case .colours: return pink; case .animals: return yellow }
    }
}
struct TVCardModifier: ViewModifier {
    let focused: Bool
    let tint: Color
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    func body(content: Content) -> some View {
        content.padding(24).frame(maxWidth: .infinity)
            .background(focused ? tint.opacity(0.33) : TVTheme.panel,
                        in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(focused ? tint : .white.opacity(0.08), lineWidth: focused ? 5 : 2))
            .scaleEffect(focused && !reduceMotion ? 1.045 : 1)
            .shadow(color: focused ? tint.opacity(0.45) : .clear, radius: focused ? 22 : 0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: focused)
    }
}
extension View {
    func tvCard(focused: Bool, tint: Color = TVTheme.purple) -> some View { modifier(TVCardModifier(focused: focused, tint: tint)) }
}

import SwiftUI

struct AppTheme {
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let accent = Color("AccentColor")
    static let background = Color("BackgroundColor")
    static let card = Color("CardColor")
    static let text = Color("TextColor")
    static let warning = Color("WarningColor")
    static let success = Color("SuccessColor")
    
    // Gradient presets
    static let primaryGradient = LinearGradient(
        colors: [primary.opacity(0.8), primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [card.opacity(0.8), card],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Dynamic shadows based on color scheme
    static func cardShadow(for colorScheme: ColorScheme) -> (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        colorScheme == .dark ? 
            (color: .black.opacity(0.3), radius: 10, x: 0, y: 5) :
            (color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
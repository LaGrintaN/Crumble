import SwiftUI

// MARK: - Design System for Crumble App
struct DesignSystem {
    
    // MARK: - Logo
    struct Logo {
        static let name = "Logo"
        
        static func image(size: CGFloat = 100) -> some View {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        }
        
        static func image(width: CGFloat, height: CGFloat) -> some View {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
        }
        
        // Predefined logo sizes - these need to be functions, not computed properties
        static func splash() -> some View { image(size: 120) }
        static func header() -> some View { image(size: 40) }
        static func icon() -> some View { image(size: 24) }
        static func small() -> some View { image(size: 16) }
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let rubik = "Rubik"
        
        static func rubik(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            return Font.custom(rubik, size: size)
        }
        
        static func rubikItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            return Font.custom("\(rubik)-Italic", size: size)
        }
        
        // Predefined font sizes
        static let largeTitle = rubik(size: 34, weight: .bold)
        static let title = rubik(size: 28, weight: .bold)
        static let title2 = rubik(size: 22, weight: .bold)
        static let title3 = rubik(size: 20, weight: .semibold)
        static let headline = rubik(size: 17, weight: .semibold)
        static let body = rubik(size: 17, weight: .regular)
        static let callout = rubik(size: 16, weight: .regular)
        static let subheadline = rubik(size: 15, weight: .regular)
        static let footnote = rubik(size: 13, weight: .regular)
        static let caption = rubik(size: 12, weight: .regular)
        static let caption2 = rubik(size: 11, weight: .regular)
    }
    
    // MARK: - Colors
    struct Colors {
        // Primary colors - your chosen purple
        static let primary = Color(hex: "#7233F5") // #7233F5
        static let primaryDark = Color(hex: "#5A28C4")
        static let primaryLight = Color(hex: "#8B5CF6")
        
        // Secondary colors - complementary to your primary
        static let secondary = Color(hex: "#F59E0B") // Complementary orange
        static let secondaryDark = Color(hex: "#D97706")
        static let secondaryLight = Color(hex: "#FBBF24")
        
        // Background colors
        static let background = Color(hex: "#FAFAFA")
        static let backgroundSecondary = Color.white
        
        // Text colors - your chosen palette
        static let textPrimary = Color(hex: "#2A1562") // Title color #2A1562
        static let textSecondary = Color(hex: "#6D6983") // Text color #6D6983
        static let textTertiary = Color(hex: "#9CA3AF")
        
        // Status colors
        static let success = Color(red: 0.2, green: 0.8, blue: 0.2)
        static let warning = Color(red: 1.0, green: 0.8, blue: 0.0)
        static let error = Color(red: 1.0, green: 0.2, blue: 0.2)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
}

// MARK: - Font Extensions for Easy Access
extension Font {
    static let rubikLargeTitle = DesignSystem.Fonts.largeTitle
    static let rubikTitle = DesignSystem.Fonts.title
    static let rubikTitle2 = DesignSystem.Fonts.title2
    static let rubikTitle3 = DesignSystem.Fonts.title3
    static let rubikHeadline = DesignSystem.Fonts.headline
    static let rubikBody = DesignSystem.Fonts.body
    static let rubikCallout = DesignSystem.Fonts.callout
    static let rubikSubheadline = DesignSystem.Fonts.subheadline
    static let rubikFootnote = DesignSystem.Fonts.footnote
    static let rubikCaption = DesignSystem.Fonts.caption
    static let rubikCaption2 = DesignSystem.Fonts.caption2
}

// MARK: - Color Extensions for Easy Access
extension Color {
    static let crumblePrimary = DesignSystem.Colors.primary
    static let crumbleSecondary = DesignSystem.Colors.secondary
    static let crumbleBackground = DesignSystem.Colors.background
    static let crumbleTextPrimary = DesignSystem.Colors.textPrimary
    static let crumbleTextSecondary = DesignSystem.Colors.textSecondary
    
    // MARK: - Hex Color Support
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

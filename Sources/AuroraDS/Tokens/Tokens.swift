import Foundation

/// Platform-neutral design tokens. UIKit and SwiftUI layers translate them into UIColor/Color/Font,
/// so both stacks are pixel-identical and a brand change is a one-file edit.
public struct RGBA: Equatable, Sendable {
    public let r: Double, g: Double, b: Double, a: Double

    public init(hex: UInt32, alpha: Double = 1) {
        r = Double((hex >> 16) & 0xFF) / 255
        g = Double((hex >> 8) & 0xFF) / 255
        b = Double(hex & 0xFF) / 255
        a = alpha
    }

    /// WCAG relative luminance.
    public var luminance: Double {
        func channel(_ c: Double) -> Double { c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4) }
        return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
    }

    /// WCAG contrast ratio (1…21). Text needs ≥ 4.5 (AA).
    public func contrast(with other: RGBA) -> Double {
        let (l1, l2) = (max(luminance, other.luminance), min(luminance, other.luminance))
        return (l1 + 0.05) / (l2 + 0.05)
    }
}

public struct ColorToken: Equatable, Sendable {
    public let light: RGBA
    public let dark: RGBA
}

public enum DSColor {
    public static let primary = ColorToken(light: RGBA(hex: 0x1F3864), dark: RGBA(hex: 0x9DBEF0))
    public static let onPrimary = ColorToken(light: RGBA(hex: 0xFFFFFF), dark: RGBA(hex: 0x0B1A33))
    public static let surface = ColorToken(light: RGBA(hex: 0xFFFFFF), dark: RGBA(hex: 0x121417))
    public static let onSurface = ColorToken(light: RGBA(hex: 0x1B1D21), dark: RGBA(hex: 0xE6E8EC))
    public static let success = ColorToken(light: RGBA(hex: 0x1B7F4F), dark: RGBA(hex: 0x6FD3A0))
    public static let danger = ColorToken(light: RGBA(hex: 0xB3261E), dark: RGBA(hex: 0xF2B8B5))
    public static let warning = ColorToken(light: RGBA(hex: 0x8A5300), dark: RGBA(hex: 0xFFC56E))
    public static let neutral = ColorToken(light: RGBA(hex: 0x5F6368), dark: RGBA(hex: 0xA8ADB4))
}

public enum DSSpacing {
    public static let xxs: Double = 2, xs: Double = 4, sm: Double = 8, md: Double = 16, lg: Double = 24, xl: Double = 32
}

public enum DSRadius {
    public static let sm: Double = 6, md: Double = 12, lg: Double = 20
}

/// Typography maps to Dynamic Type text styles, so every component scales with accessibility settings.
public enum DSTypography: String, CaseIterable, Sendable {
    case display, title, headline, body, caption

    public var pointSize: Double {
        switch self {
        case .display: return 34
        case .title: return 22
        case .headline: return 17
        case .body: return 17
        case .caption: return 12
        }
    }

    public var isBold: Bool { self == .display || self == .title || self == .headline }
}

public enum DSButtonKind: String, CaseIterable, Sendable {
    case primary, secondary, destructive, ghost
}

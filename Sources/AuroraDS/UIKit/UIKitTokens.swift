#if canImport(UIKit)
import UIKit

public extension UIColor {
    /// Dynamic color that follows light/dark mode automatically.
    convenience init(_ token: ColorToken) {
        self.init { traits in
            let c = traits.userInterfaceStyle == .dark ? token.dark : token.light
            return UIColor(red: c.r, green: c.g, blue: c.b, alpha: c.a)
        }
    }
}

public extension UIFont {
    static func ds(_ style: DSTypography) -> UIFont {
        let textStyle: UIFont.TextStyle = {
            switch style {
            case .display: return .largeTitle
            case .title: return .title2
            case .headline: return .headline
            case .body: return .body
            case .caption: return .caption1
            }
        }()
        let base = UIFont.systemFont(ofSize: style.pointSize, weight: style.isBold ? .semibold : .regular)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: base)
    }
}
#endif

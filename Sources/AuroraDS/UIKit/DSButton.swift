#if canImport(UIKit)
import UIKit

public final class DSButton: UIButton {

    public var kind: DSButtonKind { didSet { applyStyle() } }

    public var isLoading = false {
        didSet {
            configuration?.showsActivityIndicator = isLoading
            isUserInteractionEnabled = !isLoading
            accessibilityValue = isLoading ? "Carregando" : nil
        }
    }

    public init(title: String, kind: DSButtonKind = .primary, action: UIAction? = nil) {
        self.kind = kind
        super.init(frame: .zero)
        configuration = .filled()
        configuration?.title = title
        configuration?.cornerStyle = .large
        configuration?.contentInsets = .init(top: DSSpacing.md, leading: DSSpacing.lg, bottom: DSSpacing.md, trailing: DSSpacing.lg)
        configuration?.titleTextAttributesTransformer = .init { attrs in
            var a = attrs
            a.font = .ds(.headline)
            return a
        }
        if let action { addAction(action, for: .touchUpInside) }
        // 44 pt minimum touch target (Human Interface Guidelines).
        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        applyStyle()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    private func applyStyle() {
        let (background, foreground): (UIColor, UIColor) = {
            switch kind {
            case .primary: return (UIColor(DSColor.primary), UIColor(DSColor.onPrimary))
            case .secondary: return (UIColor(DSColor.primary).withAlphaComponent(0.12), UIColor(DSColor.primary))
            case .destructive: return (UIColor(DSColor.danger), .white)
            case .ghost: return (.clear, UIColor(DSColor.primary))
            }
        }()
        configuration?.baseBackgroundColor = background
        configuration?.baseForegroundColor = foreground
    }
}
#endif

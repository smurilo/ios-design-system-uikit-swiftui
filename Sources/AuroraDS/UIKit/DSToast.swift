#if canImport(UIKit)
import UIKit

public enum DSToast {
    public enum Style { case success, error, info }

    /// Non-blocking feedback that also respects VoiceOver and Reduce Motion.
    @MainActor
    public static func show(_ text: String, style: Style = .info, in view: UIView, duration: TimeInterval = 2.5) {
        let label = PaddingLabel()
        label.text = text
        label.font = .ds(.body)
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = {
            switch style {
            case .success: return UIColor(DSColor.success)
            case .error: return UIColor(DSColor.danger)
            case .info: return UIColor(DSColor.neutral)
            }
        }()
        label.layer.cornerRadius = DSRadius.md
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -DSSpacing.md),
        ])
        UIAccessibility.post(notification: .announcement, argument: text)
        let animate = !UIAccessibility.isReduceMotionEnabled
        label.alpha = 0
        UIView.animate(withDuration: animate ? 0.25 : 0) { label.alpha = 1 }
        UIView.animate(withDuration: animate ? 0.25 : 0, delay: duration, options: []) { label.alpha = 0 } completion: { _ in
            label.removeFromSuperview()
        }
    }

    private final class PaddingLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)))
        }

        override var intrinsicContentSize: CGSize {
            let s = super.intrinsicContentSize
            return CGSize(width: s.width + 32, height: s.height + 24)
        }
    }
}
#endif

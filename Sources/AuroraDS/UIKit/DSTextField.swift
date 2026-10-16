#if canImport(UIKit)
import UIKit

/// Labelled text field with mask, inline validation and accessible error announcement.
public final class DSTextField: UIView, UITextFieldDelegate {

    public let textField = UITextField()
    private let label = UILabel()
    private let message = UILabel()
    private let mask: InputMask?
    private let validator: ((String) -> FieldValidation)?
    public private(set) var validation: FieldValidation = .idle

    public var onChange: ((String) -> Void)?
    public var rawValue: String { mask?.unmask(textField.text ?? "") ?? (textField.text ?? "") }

    public init(title: String, placeholder: String? = nil, mask: InputMask? = nil, validator: ((String) -> FieldValidation)? = nil) {
        self.mask = mask
        self.validator = validator
        super.init(frame: .zero)
        label.text = title
        label.font = .ds(.caption)
        label.adjustsFontForContentSizeCategory = true
        textField.placeholder = placeholder
        textField.font = .ds(.body)
        textField.adjustsFontForContentSizeCategory = true
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.accessibilityLabel = title
        if mask?.keyboardIsNumeric == true { textField.keyboardType = .numberPad }
        message.font = .ds(.caption)
        message.numberOfLines = 0
        message.isHidden = true

        let stack = UIStackView(arrangedSubviews: [label, textField, message])
        stack.axis = .vertical
        stack.spacing = DSSpacing.xs
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    public func textField(_ field: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let mask, let current = field.text, let r = Range(range, in: current) else { return true }
        field.text = mask.apply(current.replacingCharacters(in: r, with: string))
        field.sendActions(for: .editingChanged)
        onChange?(field.text ?? "")
        return false
    }

    public func textFieldDidEndEditing(_ field: UITextField) {
        guard let validator else { return }
        render(validator(field.text ?? ""))
    }

    private func render(_ state: FieldValidation) {
        validation = state
        switch state {
        case .idle, .valid:
            message.isHidden = true
            textField.layer.borderWidth = 0
        case let .invalid(text):
            message.text = text
            message.textColor = UIColor(DSColor.danger)
            message.isHidden = false
            textField.layer.borderColor = UIColor(DSColor.danger).cgColor
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = DSRadius.sm
            UIAccessibility.post(notification: .announcement, argument: text)
        }
    }
}
#endif

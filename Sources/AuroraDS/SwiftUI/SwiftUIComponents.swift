#if canImport(SwiftUI)
import SwiftUI

public extension Color {
    init(_ token: ColorToken, scheme: ColorScheme) {
        let c = scheme == .dark ? token.dark : token.light
        self.init(red: c.r, green: c.g, blue: c.b, opacity: c.a)
    }
}

public extension Font {
    static func ds(_ style: DSTypography) -> Font {
        let base: Font = {
            switch style {
            case .display: return .largeTitle
            case .title: return .title2
            case .headline: return .headline
            case .body: return .body
            case .caption: return .caption
            }
        }()
        return style.isBold ? base.weight(.semibold) : base
    }
}

/// Same visual contract as the UIKit DSButton.
public struct DSButtonStyle: ButtonStyle {
    let kind: DSButtonKind
    @Environment(\.colorScheme) private var scheme
    @Environment(\.isEnabled) private var isEnabled

    public init(_ kind: DSButtonKind = .primary) { self.kind = kind }

    public func makeBody(configuration: Configuration) -> some View {
        let primary = Color(DSColor.primary, scheme: scheme)
        let (background, foreground): (Color, Color) = {
            switch kind {
            case .primary: return (primary, Color(DSColor.onPrimary, scheme: scheme))
            case .secondary: return (primary.opacity(0.12), primary)
            case .destructive: return (Color(DSColor.danger, scheme: scheme), .white)
            case .ghost: return (.clear, primary)
            }
        }()
        return configuration.label
            .font(.ds(.headline))
            .frame(maxWidth: .infinity, minHeight: 44)
            .padding(.horizontal, DSSpacing.lg)
            .background(background, in: RoundedRectangle(cornerRadius: DSRadius.lg))
            .foregroundStyle(foreground)
            .opacity(isEnabled ? (configuration.isPressed ? 0.8 : 1) : 0.4)
    }
}

public struct DSTextFieldView: View {
    let title: String
    @Binding var text: String
    let mask: InputMask?
    let validator: ((String) -> FieldValidation)?
    @State private var validation: FieldValidation = .idle
    @FocusState private var focused: Bool
    @Environment(\.colorScheme) private var scheme

    public init(_ title: String, text: Binding<String>, mask: InputMask? = nil, validator: ((String) -> FieldValidation)? = nil) {
        self.title = title
        _text = text
        self.mask = mask
        self.validator = validator
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(title).font(.ds(.caption))
            TextField(title, text: $text)
                .font(.ds(.body))
                .focused($focused)
                .padding(DSSpacing.sm)
                .frame(minHeight: 44)
                .overlay(RoundedRectangle(cornerRadius: DSRadius.sm)
                    .stroke(isInvalid ? Color(DSColor.danger, scheme: scheme) : Color(DSColor.neutral, scheme: scheme).opacity(0.4)))
                #if os(iOS)
                .keyboardType(mask == nil ? .default : .numberPad)
                #endif
                .onChange(of: text) { newValue in
                    if let mask, mask.apply(newValue) != newValue { text = mask.apply(newValue) }
                }
                .onChange(of: focused) { isFocused in
                    if !isFocused, let validator { validation = validator(text) }
                }
            if case let .invalid(message) = validation {
                Text(message).font(.ds(.caption)).foregroundStyle(Color(DSColor.danger, scheme: scheme))
                    .accessibilityAddTraits(.isStaticText)
            }
        }
    }

    private var isInvalid: Bool {
        if case .invalid = validation { return true }
        return false
    }
}

public struct DSBadge: View {
    public enum Tone { case success, warning, danger, neutral }
    let text: String
    let tone: Tone
    @Environment(\.colorScheme) private var scheme

    public init(_ text: String, tone: Tone = .neutral) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        let token: ColorToken = {
            switch tone {
            case .success: return DSColor.success
            case .warning: return DSColor.warning
            case .danger: return DSColor.danger
            case .neutral: return DSColor.neutral
            }
        }()
        Text(text)
            .font(.ds(.caption).weight(.semibold))
            .padding(.horizontal, DSSpacing.sm)
            .padding(.vertical, DSSpacing.xxs)
            .background(Color(token, scheme: scheme).opacity(0.15), in: Capsule())
            .foregroundStyle(Color(token, scheme: scheme))
    }
}

public struct DSCard<Content: View>: View {
    let content: Content
    @Environment(\.colorScheme) private var scheme

    public init(@ViewBuilder content: () -> Content) { self.content = content() }

    public var body: some View {
        content
            .padding(DSSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(DSColor.surface, scheme: scheme), in: RoundedRectangle(cornerRadius: DSRadius.md))
            .shadow(color: .black.opacity(scheme == .dark ? 0 : 0.08), radius: 8, y: 2)
    }
}
#endif

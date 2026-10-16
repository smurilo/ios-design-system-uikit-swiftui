import Foundation

/// Input masks applied while typing. Pure functions, shared by the UIKit and SwiftUI text fields.
public enum InputMask: Equatable, Sendable {
    case cpf, cnpj, phone, cep, currencyBRL

    /// Formats raw user input; extra characters beyond the mask are dropped.
    public func apply(_ input: String) -> String {
        let digits = input.filter(\.isNumber)
        switch self {
        case .cpf: return Self.pattern("###.###.###-##", digits)
        case .cnpj: return Self.pattern("##.###.###/####-##", digits)
        case .cep: return Self.pattern("#####-###", digits)
        case .phone: return Self.pattern(digits.count > 10 ? "(##) #####-####" : "(##) ####-####", digits)
        case .currencyBRL: return Self.currency(digits)
        }
    }

    /// Digits only, for sending to the backend.
    public func unmask(_ text: String) -> String { text.filter(\.isNumber) }

    public var keyboardIsNumeric: Bool { true }

    private static func pattern(_ mask: String, _ digits: String) -> String {
        var result = ""
        var iterator = digits.makeIterator()
        var pending = iterator.next()
        for symbol in mask {
            guard let digit = pending else { break }
            if symbol == "#" {
                result.append(digit)
                pending = iterator.next()
            } else {
                result.append(symbol)
            }
        }
        return result
    }

    /// Cash-register style: typing 1, 2, 3, 4 shows R$ 0,01 → R$ 0,12 → R$ 1,23 → R$ 12,34.
    private static func currency(_ digits: String) -> String {
        let trimmed = String(digits.drop { $0 == "0" }.prefix(13))
        let padded = String(repeating: "0", count: max(0, 3 - trimmed.count)) + trimmed
        let cents = padded.suffix(2)
        let reais = String(padded.dropLast(2))
        var grouped = ""
        for (i, ch) in reais.reversed().enumerated() {
            if i > 0 && i % 3 == 0 { grouped.append(".") }
            grouped.append(ch)
        }
        return "R$ \(String(grouped.reversed())),\(cents)"
    }
}

public enum FieldValidation: Equatable, Sendable {
    case idle, valid, invalid(message: String)
}

public enum Validators {
    public static func cpf(_ text: String) -> FieldValidation {
        let n = text.compactMap(\.wholeNumberValue)
        guard !n.isEmpty else { return .idle }
        guard n.count == 11, Set(n).count > 1 else { return .invalid(message: "CPF incompleto ou inválido") }
        func dv(_ len: Int) -> Int {
            var sum = 0
            for i in 0..<len { sum += n[i] * (len + 1 - i) }
            let r = (sum * 10) % 11
            return r == 10 ? 0 : r
        }
        return dv(9) == n[9] && dv(10) == n[10] ? .valid : .invalid(message: "CPF inválido")
    }

    public static func email(_ text: String) -> FieldValidation {
        guard !text.isEmpty else { return .idle }
        return text.range(of: #"^[\w.+-]+@[\w-]+(\.[\w-]+)+$"#, options: .regularExpression) != nil
            ? .valid : .invalid(message: "E-mail inválido")
    }
}

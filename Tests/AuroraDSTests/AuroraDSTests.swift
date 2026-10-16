import XCTest
@testable import AuroraDS

final class InputMaskTests: XCTestCase {

    func testDocumentMasks() {
        XCTAssertEqual(InputMask.cpf.apply("52998224725"), "529.982.247-25")
        XCTAssertEqual(InputMask.cpf.apply("5299"), "529.9")
        XCTAssertEqual(InputMask.cpf.apply("529.982.247-2599999"), "529.982.247-25")
        XCTAssertEqual(InputMask.cnpj.apply("11222333000181"), "11.222.333/0001-81")
        XCTAssertEqual(InputMask.cep.apply("57035000"), "57035-000")
    }

    func testPhoneSwitchesBetweenLandlineAndMobile() {
        XCTAssertEqual(InputMask.phone.apply("8233334444"), "(82) 3333-4444")
        XCTAssertEqual(InputMask.phone.apply("82999990000"), "(82) 99999-0000")
    }

    func testCurrencyBehavesLikeCashRegister() {
        XCTAssertEqual(InputMask.currencyBRL.apply("1"), "R$ 0,01")
        XCTAssertEqual(InputMask.currencyBRL.apply("1234"), "R$ 12,34")
        XCTAssertEqual(InputMask.currencyBRL.apply("R$ 1.234.567,89"), "R$ 1.234.567,89")
        XCTAssertEqual(InputMask.currencyBRL.apply(""), "R$ 0,00")
        XCTAssertEqual(InputMask.currencyBRL.unmask("R$ 12,34"), "1234")
    }

    func testValidators() {
        XCTAssertEqual(Validators.cpf(""), .idle)
        XCTAssertEqual(Validators.cpf("529.982.247-25"), .valid)
        XCTAssertEqual(Validators.cpf("529.982.247-24"), .invalid(message: "CPF inválido"))
        XCTAssertEqual(Validators.cpf("111.111.111-11"), .invalid(message: "CPF incompleto ou inválido"))
        XCTAssertEqual(Validators.email("ana@banco.com.br"), .valid)
        XCTAssertNotEqual(Validators.email("ana@"), .valid)
    }
}

/// Guards accessibility at build time: any token change that breaks WCAG AA contrast fails CI.
final class ContrastTests: XCTestCase {

    func testTextOnSurfaceMeetsWCAGAAInBothThemes() {
        XCTAssertGreaterThanOrEqual(DSColor.onSurface.light.contrast(with: DSColor.surface.light), 4.5)
        XCTAssertGreaterThanOrEqual(DSColor.onSurface.dark.contrast(with: DSColor.surface.dark), 4.5)
    }

    func testButtonLabelsMeetWCAGAA() {
        XCTAssertGreaterThanOrEqual(DSColor.onPrimary.light.contrast(with: DSColor.primary.light), 4.5)
        XCTAssertGreaterThanOrEqual(DSColor.onPrimary.dark.contrast(with: DSColor.primary.dark), 4.5)
        XCTAssertGreaterThanOrEqual(RGBA(hex: 0xFFFFFF).contrast(with: DSColor.danger.light), 4.5)
    }

    func testStatusColorsAreReadableOnSurface() {
        for token in [DSColor.success, DSColor.danger, DSColor.warning, DSColor.neutral] {
            XCTAssertGreaterThanOrEqual(token.light.contrast(with: DSColor.surface.light), 4.5)
            XCTAssertGreaterThanOrEqual(token.dark.contrast(with: DSColor.surface.dark), 4.5)
        }
    }

    func testContrastFormulaReferenceValues() {
        XCTAssertEqual(RGBA(hex: 0x000000).contrast(with: RGBA(hex: 0xFFFFFF)), 21, accuracy: 0.01)
        XCTAssertEqual(RGBA(hex: 0x777777).contrast(with: RGBA(hex: 0xFFFFFF)), 4.48, accuracy: 0.01)
    }
}

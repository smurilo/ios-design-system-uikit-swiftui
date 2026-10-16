# Aurora DS — Design System iOS (UIKit + SwiftUI)

Biblioteca de **componentização** que entrega os mesmos componentes para **UIKit** (apps legados) e **SwiftUI** (apps novos) a partir de **tokens únicos**. É distribuída por **CocoaPods (com subspecs)** e por **Swift Package Manager**, e o próprio build **verifica o contraste WCAG**.

> Uso transversal: apps bancários, de telecom e de saúde

## Stack
Swift 5.9 • **UIKit** (UIButton.Configuration, UIFontMetrics, cores dinâmicas) • **SwiftUI** (ButtonStyle, @FocusState, ViewBuilder) • Design Tokens • Dynamic Type • Dark Mode • VoiceOver • **CocoaPods** (subspecs `Core`/`UIKit`/`SwiftUI` + `test_spec`) • **Swift Package Manager** • XCTest • XcodeGen (app catálogo)

## Estrutura

```
Sources/AuroraDS/
├── Tokens/        DSColor (claro/escuro), DSTypography, DSSpacing, DSRadius, contraste WCAG
├── Formatting/    InputMask (CPF, CNPJ, telefone fixo/celular, CEP, moeda estilo caixa registradora), Validators
├── UIKit/         DSButton, DSTextField (máscara + validação + anúncio VoiceOver), DSToast
└── SwiftUI/       DSButtonStyle, DSTextFieldView, DSBadge, DSCard
Example/Catalog    app catálogo com UIKit e SwiftUI lado a lado
```

### Princípios
- **Tokens independentes de plataforma** (`RGBA`): UIKit e SwiftUI ficam visualmente idênticos, e trocar a marca exige editar um único arquivo.
- **Acessibilidade verificada no build**: testes falham se algum par de cores ficar abaixo de **4,5:1 (WCAG AA)** no tema claro ou escuro.
- **Dynamic Type** em toda a tipografia e **área de toque mínima de 44 pt**.
- **Máscaras como funções puras**, compartilhadas pelos campos UIKit e SwiftUI e testadas sem simulador.
- **Adoção gradual**: um app legado usa só `pod 'AuroraDS/UIKit'`; um app novo, só o SwiftUI.

## Instalação
```ruby
# CocoaPods
pod 'AuroraDS', :git => 'https://github.com/smsmurilo/ios-design-system-uikit-swiftui.git', :tag => '1.2.0'
pod 'AuroraDS/UIKit'          # somente UIKit
```
```swift
// Swift Package Manager
.package(url: "https://github.com/smsmurilo/ios-design-system-uikit-swiftui.git", from: "1.2.0")
```

## Uso
```swift
// UIKit
let cpf = DSTextField(title: "CPF", mask: .cpf, validator: Validators.cpf)
let pay = DSButton(title: "Pagar", kind: .primary, action: UIAction { _ in … })

// SwiftUI
DSTextFieldView("Valor", text: $amount, mask: .currencyBRL)
Button("Cancelar") { … }.buttonStyle(DSButtonStyle(.destructive))
```

## Testes e catálogo
```bash
swift test                                         # máscaras, validadores e contraste (macOS ou Linux)
cd Example && xcodegen && open AuroraCatalog.xcodeproj
```

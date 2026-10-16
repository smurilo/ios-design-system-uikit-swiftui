import SwiftUI
import UIKit
import AuroraDS

/// Living catalog: every component in both stacks, side by side, in light and dark mode.
@main
struct CatalogApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SwiftUICatalog().tabItem { Label("SwiftUI", systemImage: "swift") }
                UIKitCatalog().ignoresSafeArea().tabItem { Label("UIKit", systemImage: "square.stack.3d.up") }
            }
        }
    }
}

struct SwiftUICatalog: View {
    @State private var cpf = ""
    @State private var amount = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: DSSpacing.md) {
                    DSCard {
                        VStack(alignment: .leading, spacing: DSSpacing.sm) {
                            Text("Badges").font(.ds(.title))
                            HStack { DSBadge("Pago", tone: .success); DSBadge("Vence hoje", tone: .warning); DSBadge("Atrasado", tone: .danger) }
                        }
                    }
                    DSTextFieldView("CPF", text: $cpf, mask: .cpf, validator: Validators.cpf)
                    DSTextFieldView("Valor", text: $amount, mask: .currencyBRL)
                    ForEach(DSButtonKind.allCases, id: \.self) { kind in
                        Button(kind.rawValue.capitalized) {}.buttonStyle(DSButtonStyle(kind))
                    }
                }
                .padding()
            }
            .navigationTitle("Aurora DS")
        }
    }
}

struct UIKitCatalog: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(DSColor.surface)
        let stack = UIStackView(arrangedSubviews:
            [DSTextField(title: "CPF", mask: .cpf, validator: Validators.cpf),
             DSTextField(title: "Telefone", mask: .phone)]
            + DSButtonKind.allCases.map { kind in
                DSButton(title: kind.rawValue.capitalized, kind: kind, action: UIAction { _ in
                    DSToast.show("Botão \(kind.rawValue) tocado", style: kind == .destructive ? .error : .success, in: vc.view)
                })
            })
        stack.axis = .vertical
        stack.spacing = DSSpacing.md
        stack.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor, constant: DSSpacing.lg),
            stack.leadingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.trailingAnchor),
        ])
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

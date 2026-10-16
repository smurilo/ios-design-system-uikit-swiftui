Pod::Spec.new do |s|
  s.name          = 'AuroraDS'
  s.version       = '1.2.0'
  s.summary       = 'Design System com componentes UIKit e SwiftUI baseados nos mesmos tokens.'
  s.description   = 'Tokens de cor, tipografia (Dynamic Type) e espaçamento; botões, campos com máscara (CPF, CNPJ, telefone, moeda), cards, badges e toasts para UIKit e SwiftUI.'
  s.homepage      = 'https://github.com/smurilo/ios-design-system-uikit-swiftui'
  s.license       = { :type => 'MIT' }
  s.author        = { 'Sérgio Murilo' => 'smsmurilo@gmail.com' }
  s.source        = { :git => 'https://github.com/smurilo/ios-design-system-uikit-swiftui.git', :tag => s.version.to_s }
  s.platform      = :ios, '15.0'
  s.swift_version = '5.9'

  # Subspecs let apps adopt only what they use: pod 'AuroraDS/UIKit' in legacy apps, 'AuroraDS/SwiftUI' in new ones.
  s.default_subspecs = 'UIKit', 'SwiftUI'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/AuroraDS/Tokens/**/*.swift', 'Sources/AuroraDS/Formatting/**/*.swift'
  end

  s.subspec 'UIKit' do |ui|
    ui.dependency 'AuroraDS/Core'
    ui.source_files = 'Sources/AuroraDS/UIKit/**/*.swift'
    ui.frameworks = 'UIKit'
  end

  s.subspec 'SwiftUI' do |sw|
    sw.dependency 'AuroraDS/Core'
    sw.source_files = 'Sources/AuroraDS/SwiftUI/**/*.swift'
    sw.frameworks = 'SwiftUI'
  end

  s.test_spec 'Tests' do |t|
    t.source_files = 'Tests/AuroraDSTests/**/*.swift'
  end
end

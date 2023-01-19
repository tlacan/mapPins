// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum General {
    /// Next
    internal static let next = L10n.tr("Localizable", "general.next", fallback: "Next")
    /// Localizable.strings
    ///   MapPins
    /// 
    ///   Created by thomas lacan on 11/01/2023.
    internal static let ok = L10n.tr("Localizable", "general.ok", fallback: "OK")
  }
  internal enum Intro {
    /// Welcome!
    internal static let title = L10n.tr("Localizable", "intro.title", fallback: "Welcome!")
    internal enum Step1 {
      /// Pins your favorite places!
      internal static let description = L10n.tr("Localizable", "intro.step1.description", fallback: "Pins your favorite places!")
      /// You visited it, want to rember if you liked it, how it looked like.
      internal static let subtitle = L10n.tr("Localizable", "intro.step1.subtitle", fallback: "You visited it, want to rember if you liked it, how it looked like.")
    }
    internal enum Step2 {
      /// Rate them and add pictures.
      internal static let description = L10n.tr("Localizable", "intro.step2.description", fallback: "Rate them and add pictures.")
    }
    internal enum Step3 {
      /// Let's Go
      internal static let action = L10n.tr("Localizable", "intro.step3.action", fallback: "Let's Go")
      /// You will be able to find them on map or in list to get them even easily.
      internal static let description = L10n.tr("Localizable", "intro.step3.description", fallback: "You will be able to find them on map or in list to get them even easily.")
    }
  }
  internal enum Onboarding {
    internal enum Name {
      /// We would like to know, what is your name?
      internal static let description = L10n.tr("Localizable", "onboarding.name.description", fallback: "We would like to know, what is your name?")
      /// Name
      internal static let placeholder = L10n.tr("Localizable", "onboarding.name.placeholder", fallback: "Name")
      /// Hey!
      internal static let title = L10n.tr("Localizable", "onboarding.name.title", fallback: "Hey!")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

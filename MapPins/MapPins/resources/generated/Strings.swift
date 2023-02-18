// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Category {
    /// Accomodation
    internal static let accomodation = L10n.tr("Localizable", "category.accomodation", fallback: "Accomodation")
    /// Bakery
    internal static let bakery = L10n.tr("Localizable", "category.bakery", fallback: "Bakery")
    /// Bar
    internal static let bar = L10n.tr("Localizable", "category.bar", fallback: "Bar")
    /// Coffee
    internal static let coffee = L10n.tr("Localizable", "category.coffee", fallback: "Coffee")
    /// Restaurant
    internal static let restaurant = L10n.tr("Localizable", "category.restaurant", fallback: "Restaurant")
    /// Site
    internal static let site = L10n.tr("Localizable", "category.site", fallback: "Site")
  }
  internal enum CreatePin {
    /// Address
    internal static let address = L10n.tr("Localizable", "createPin.address", fallback: "Address")
    /// Pick a category
    internal static let category = L10n.tr("Localizable", "createPin.category", fallback: "Pick a category")
    /// Images
    internal static let images = L10n.tr("Localizable", "createPin.images", fallback: "Images")
    /// Name
    internal static let name = L10n.tr("Localizable", "createPin.name", fallback: "Name")
    /// Pictures
    internal static let pictures = L10n.tr("Localizable", "createPin.pictures", fallback: "Pictures")
    /// Rate
    internal static let rate = L10n.tr("Localizable", "createPin.rate", fallback: "Rate")
    /// Let's Add a Pin
    internal static let title = L10n.tr("Localizable", "createPin.title", fallback: "Let's Add a Pin")
    internal enum Image {
      /// Add From Camera
      internal static let camera = L10n.tr("Localizable", "createPin.image.camera", fallback: "Add From Camera")
      /// Add From Library
      internal static let library = L10n.tr("Localizable", "createPin.image.library", fallback: "Add From Library")
    }
  }
  internal enum EditPin {
    internal enum Button {
      /// View On Map
      internal static let viewOnMap = L10n.tr("Localizable", "editPin.button.viewOnMap", fallback: "View On Map")
    }
  }
  internal enum Error {
    /// Impossible to get coordinates for this place.
    internal static let geocodeAddress = L10n.tr("Localizable", "error.geocodeAddress", fallback: "Impossible to get coordinates for this place.")
  }
  internal enum General {
    /// Delete
    internal static let delete = L10n.tr("Localizable", "general.delete", fallback: "Delete")
    /// Next
    internal static let next = L10n.tr("Localizable", "general.next", fallback: "Next")
    /// No Result
    internal static let noResult = L10n.tr("Localizable", "general.noResult", fallback: "No Result")
    /// Localizable.strings
    ///   MapPins
    /// 
    ///   Created by thomas lacan on 11/01/2023.
    internal static let ok = L10n.tr("Localizable", "general.ok", fallback: "OK")
    /// Save
    internal static let save = L10n.tr("Localizable", "general.save", fallback: "Save")
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
  internal enum List {
    /// List
    internal static let title = L10n.tr("Localizable", "list.title", fallback: "List")
  }
  internal enum Map {
    internal enum Directions {
      /// Directions
      internal static let button = L10n.tr("Localizable", "map.directions.button", fallback: "Directions")
    }
    internal enum Google {
      /// Google Maps
      internal static let button = L10n.tr("Localizable", "map.google.button", fallback: "Google Maps")
    }
    internal enum Maps {
      /// Maps
      internal static let button = L10n.tr("Localizable", "map.maps.button", fallback: "Maps")
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
  internal enum PinFilterView {
    /// Category Filter
    internal static let title = L10n.tr("Localizable", "pinFilterView.title", fallback: "Category Filter")
  }
  internal enum Search {
    /// Search Address
    internal static let placeholder = L10n.tr("Localizable", "search.placeholder", fallback: "Search Address")
    /// Search
    internal static let title = L10n.tr("Localizable", "search.title", fallback: "Search")
  }
  internal enum Settings {
    internal enum Acknowledgements {
      /// Acknowledgements
      internal static let entry = L10n.tr("Localizable", "settings.acknowledgements.entry", fallback: "Acknowledgements")
    }
    internal enum TransportMode {
      /// Transport Mode
      internal static let entry = L10n.tr("Localizable", "settings.transportMode.entry", fallback: "Transport Mode")
    }
  }
  internal enum Tab {
    internal enum List {
      /// List
      internal static let title = L10n.tr("Localizable", "tab.list.title", fallback: "List")
    }
    internal enum Map {
      /// Map
      internal static let title = L10n.tr("Localizable", "tab.map.title", fallback: "Map")
    }
    internal enum Settings {
      /// Settings
      internal static let title = L10n.tr("Localizable", "tab.settings.title", fallback: "Settings")
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

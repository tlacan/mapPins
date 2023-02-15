//
//  MapPinSelectedView.swift
//  MapPins
//
//  Created by thomas lacan on 15/02/2023.
//

import SwiftUI
import StarRating
import MapKit

struct MapPinSelectedView: View {
    let engine: Engine
    let pin: PinModel

    @ObservedObject var viewModel: MapScreenViewModel
    @StateObject var imagesViewModel: PinImagesViewModel

    @State var starConfig: StarRatingConfiguration

    init(engine: Engine, pin: PinModel, viewModel: MapScreenViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _imagesViewModel = StateObject(wrappedValue: PinImagesViewModel(pin: pin))
        self.pin = pin
        self.engine = engine
        let starConfig = UIProperties.Star.configuration
        starConfig.spacing = 6
        _starConfig = State(initialValue: starConfig)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIProperties.Padding.small.rawValue) {
                pin.name.swiftUITitle()
                subtitleInfo()
                actionsButtons()
                images()
            }
            .padding(UIProperties.Padding.medium.rawValue)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $imagesViewModel.showImageDetails) {
                PinImagesDetailView(viewModel: imagesViewModel, deleteButton: false)
            }
        }
    }

    @ViewBuilder func subtitleInfo() -> some View {
        HStack(spacing: UIProperties.Padding.verySmall.rawValue) {
            if let rating = pin.rating {
                String(format: "%.1f", locale: Locale.current, rating).swiftUIDescription()
                StarRating(initialRating: rating, configuration: $starConfig)
                    .disabled(true)
                    .offset(x: -8)
            }
            HStack(spacing: UIProperties.Padding.verySmall.rawValue) {
                Text(pin.category.uiText)
                    .font(FontFamily.Poppins.bold.swiftUIFont(size: 12))
                    .foregroundColor(XCAsset.Colors.text.swiftUIColor)
                if let estimatedTime = viewModel.estimatedTime {
                    HStack {
                        Text(estimatedTime)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                        if let transportImage = engine.preferenceService.transportModeImage {
                            Image(uiImage: transportImage)
                                .foregroundColor(XCAsset.Colors.black.swiftUIColor)
                        }
                    }
                } else if viewModel.directionsETA?.isCalculating ?? false {
                    ProgressView()
                }
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: pin.rating != nil ? -18 : 0)
        }.frame(height: 12, alignment: .leading)
    }

    @ViewBuilder func actionsButtons() -> some View {
        HStack {
            if let direction = viewModel.directionsMap {
                ButtonView(image: UIImage(systemName: "arrow.uturn.right.circle.fill"), text: L10n.Map.Directions.button) {
                    engine.geoLocationService.direction = direction
                    withAnimation(.default) {
                        viewModel.showSelected = false
                    }
                }
            }
            ButtonView(image: UIImage(systemName: "map.circle.fill"), text: L10n.Map.Maps.button) {
                openSelectedInAppleMap()
            }
            ButtonView(image: UIImage(systemName: "g.circle.fill"), text: L10n.Map.Google.button) {
                openSelectedInGoogleMap()
            }
        }
    }

    func openSelectedInAppleMap() {
        guard let coordinate = viewModel.selectedPin?.address.coordinate else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = viewModel.selectedPin?.name ?? "Destination"
        mapItem.openInMaps()
    }

    func openSelectedInGoogleMap() {
        guard let coordinate = viewModel.selectedPin?.address.coordinate else { return }
        if let googleMapUrl = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(googleMapUrl) {
            if let url = URL(string: "comgooglemaps-x-callback://?center=\(coordinate.latitude),\(coordinate.longitude)") {
                UIApplication.shared.open(url, options: [:])
                return
            }
        }
        if let urlDestination = URL(string: "https://www.google.co.in/maps?center=\(coordinate.latitude),\(coordinate.longitude)") {
            UIApplication.shared.open(urlDestination)
        }
    }

    @ViewBuilder func images() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(0..<imagesViewModel.imageRows + 1, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<3) { col in
                        PinImageThumbView(viewModel: imagesViewModel, col: col, row: row)
                    }
                }
            }
        }.frame(maxWidth: .infinity)
    }
}

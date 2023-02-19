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

    struct ViewConstants {
        static var starConfig: StarRatingConfiguration {
            let starConfig = AppConstants.Star.configuration
            starConfig.spacing = 6
            return starConfig
        }

        struct SubtitleInfo {
            static let height: CGFloat = 12
            static let categoryFont: SwiftUI.Font = FontFamily.Poppins.bold.swiftUIFont(size: 12)
            static let etaFont: SwiftUI.Font = FontFamily.Poppins.regular.swiftUIFont(size: 12)
            static let ratingWidth: CGFloat = 84
        }

        struct Images {
            static let spacing: CGFloat = 2
            static let imagesPerRow = 3
        }
    }

    init(engine: Engine, pin: PinModel, viewModel: MapScreenViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _imagesViewModel = StateObject(wrappedValue: PinImagesViewModel(pin: pin))
        self.pin = pin
        self.engine = engine
        _starConfig = State(wrappedValue: ViewConstants.starConfig)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppConstants.Padding.small.rawValue) {
                pin.name.swiftUITitle()
                subtitleInfo()
                actionsButtons()
                images()
            }
            .padding(AppConstants.Padding.medium.rawValue)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $imagesViewModel.showImageDetails) {
                PinImagesDetailView(viewModel: imagesViewModel, deleteButton: false)
            }
        }
    }

    @ViewBuilder func subtitleInfo() -> some View {
        HStack(spacing: AppConstants.Padding.verySmall.rawValue) {
            if let rating = pin.rating {
                String(format: "%.1f", locale: Locale.current, rating).swiftUIDescription()
                StarRating(initialRating: rating, configuration: $starConfig)
                    .disabled(true)
                    .frame(width: ViewConstants.SubtitleInfo.ratingWidth)
            }
            HStack(spacing: AppConstants.Padding.verySmall.rawValue) {
                Text(pin.category.uiText)
                    .font(ViewConstants.SubtitleInfo.categoryFont)
                    .foregroundColor(XCAsset.Colors.text.swiftUIColor)
                if let estimatedTime = viewModel.estimatedTime {
                    HStack {
                        Text(estimatedTime)
                            .font(ViewConstants.SubtitleInfo.etaFont)
                        if let transportImage = engine.preferenceService.transportMode.image {
                            Image(uiImage: transportImage)
                                .foregroundColor(XCAsset.Colors.black.swiftUIColor)
                        }
                    }
                } else if viewModel.directionsETA?.isCalculating ?? false {
                    ProgressView()
                }
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        }.frame(height: ViewConstants.SubtitleInfo.height, alignment: .leading)
    }

    @ViewBuilder func actionsButtons() -> some View {
        HStack {
            if let direction = viewModel.directionsMap {
                ButtonView(image: UIImage(systemSymbol: .arrowUturnRightCircleFill), text: L10n.Map.Directions.button) {
                    engine.geoLocationService.direction = direction
                    withAnimation(.default) {
                        viewModel.showSelected = false
                    }
                }
            }
            ButtonView(image: UIImage(systemSymbol: .mapCircleFill), text: L10n.Map.Maps.button) {
                openSelectedInAppleMap()
            }
            ButtonView(image: UIImage(systemSymbol: .gCircleFill), text: L10n.Map.Google.button) {
                openSelectedInGoogleMap()
            }
        }
    }

    func openSelectedInAppleMap() {
        guard let coordinate = viewModel.selectedPin?.address.coordinate else { return }
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = viewModel.selectedPin?.name ?? ""
        mapItem.openInMaps()
    }

    func openSelectedInGoogleMap() {
        guard let coordinate = viewModel.selectedPin?.address.coordinate else { return }
        if let googleMapUrl = URL(string: AppConstants.URLs.googleMapApp.rawValue), UIApplication.shared.canOpenURL(googleMapUrl) {
            if let url = URL(string: "\(AppConstants.URLs.googleMapAppCenter.rawValue)\(coordinate.latitude),\(coordinate.longitude)") {
                UIApplication.shared.open(url, options: [:])
                return
            }
        }
        if let urlDestination = URL(string: "\(AppConstants.URLs.googleMapCenter.rawValue)\(coordinate.latitude),\(coordinate.longitude)") {
            UIApplication.shared.open(urlDestination)
        }
    }

    @ViewBuilder func images() -> some View {
        VStack(alignment: .leading, spacing: ViewConstants.Images.spacing) {
            ForEach(0..<imagesViewModel.imageRows + 1, id: \.self) { row in
                HStack(spacing: ViewConstants.Images.spacing) {
                    ForEach(0..<ViewConstants.Images.imagesPerRow, id: \.self) { col in
                        PinImageThumbView(viewModel: imagesViewModel, col: col, row: row)
                    }
                }
            }
        }.frame(maxWidth: .infinity)
    }
}

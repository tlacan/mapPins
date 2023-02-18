//
//  PinMapViewController.swift
//  MapPins
//
//  Created by thomas lacan on 02/02/2023.
//

import Foundation
import UIKit
import Combine
import MapKit
import SwiftUI

class PinMapViewController: UIViewController {
    let engine: Engine
    var loaded: Bool = false
    var cancellables = [AnyCancellable]()
    weak var viewModel: MapScreenViewModel?
    var centerConfigured: Bool = false

    @IBOutlet private var mapView: MKMapView!

    init(engine: Engine, viewModel: MapScreenViewModel) {
        self.engine = engine
        self.viewModel = viewModel
        super.init(nibName: "PinMapViewController", bundle: Bundle(for: Self.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        engine.geoLocationService.stopUpdateLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
        engine.geoLocationService.startUpdateLocationIfNeeded(continuous: false)
        engine.geoLocationService.$latestUserLocation.sink(receiveValue: { [weak self] location in
            if let coordinate = location?.coordinate, !(self?.centerConfigured ?? false) {
                self?.centerConfigured = true
                self?.configureCenter(coordinate)
            }
        }).store(in: &self.cancellables)

        engine.pinService.$pins.sink(receiveValue: { [weak self] pins in
            Task { @MainActor in
                self?.updateAnnotations(filters: self?.engine.preferenceService.filters ?? [], pins: pins.responseArray ?? [])
            }
        }).store(in: &self.cancellables)

        engine.preferenceService.$filters.sink { [weak self] categories in
            Task { @MainActor in
                self?.updateAnnotations(filters: categories, pins: self?.engine.pinService.pins.responseArray ?? [])
            }
        }.store(in: &self.cancellables)

        engine.geoLocationService.$direction.sink { [weak self] direction in
            Task { @MainActor in
                if let direction = direction {
                    self?.showRouteOnMap(direction: direction)
                }
            }
        }.store(in: &self.cancellables)

        viewModel?.$centerOnUser.sink { [weak self] centerOnUser in
            Task { @MainActor in
                if centerOnUser {
                    self?.configureCenter(self?.engine.geoLocationService.latestUserLocation?.coordinate ?? AppConstants.Location.parisCenter)
                }
            }
        }.store(in: &self.cancellables)

        viewModel?.$centerOnPin.sink { [weak self] centerOnPin in
            Task { @MainActor in
                if let pinCoordinate = centerOnPin?.address.coordinate {
                    self?.configureCenter(pinCoordinate)
                }
            }
        }.store(in: &self.cancellables)
    }

    func updateAnnotations(filters: [PinCategory], pins: [PinModel]) {
        mapView.removeAnnotations(mapView.annotations)
        let filteredPins = engine.preferenceService.filterPins(filters: filters, pins: pins)
        configureAnnotations(pins: filteredPins)
    }

    func configureCenter(_ center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }

    func configureMapView() {
        centerConfigured = engine.geoLocationService.latestUserLocation?.coordinate != nil
        configureCenter(engine.geoLocationService.latestUserLocation?.coordinate ?? AppConstants.Location.parisCenter)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.register(
            PinAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(
            ClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }

    private func configureAnnotations(pins: [PinModel]) {
        loaded = true
        mapView.addAnnotations(pins.map({ MapItem(pin: $0) }))
    }

    func showRouteOnMap(direction: MKDirections) {
        direction.calculate { [weak self] response, _ in
            guard let unwrappedResponse = response else { return }
            if let route = unwrappedResponse.routes.first {
                self?.mapView.removeOverlays(self?.mapView?.overlays ?? [])
                self?.mapView.addOverlay(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                                edgePadding: UIEdgeInsets(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor(Color.red)
         renderer.lineWidth = 5.0
         return renderer
    }
}

extension PinMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pinAnnotation = view.annotation as? MapItem {
            if let selectedPin = engine.pinService.pins.responseArray?.first(where: { $0.id == pinAnnotation.id }) {
                viewModel?.selectedPin = selectedPin
            }
            mapView.selectedAnnotations.removeAll()
            return
        }

        // zoom on selected annotation
        guard view is ClusterAnnotationView else { return }
        let currentSpan = mapView.region.span
        let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 2.0, longitudeDelta: currentSpan.longitudeDelta / 2.0)
        let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
        mapView.setRegion(zoomed, animated: true)
    }
}

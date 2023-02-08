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

protocol PinMapViewControllerDelegate: AnyObject {
    func didSelectPin(id: UUID)
}

class PinMapViewController: UIViewController {
    let engine: Engine
    var loaded: Bool = false
    var cancellables = [AnyCancellable]()
    weak var delegate: PinMapViewControllerDelegate?

    @IBOutlet private var mapView: MKMapView!

    init(engine: Engine, delegate: PinMapViewControllerDelegate) {
        self.engine = engine
        self.delegate = delegate
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
            if location != nil {
                self?.configureCenter()
            }
        }).store(in: &self.cancellables)

        engine.pinService.$pins.sink(receiveValue: { [weak self] pins in
            self?.updateAnnotations(filters: self?.engine.preferenceService.filters ?? [], pins: pins.responseArray ?? [])
        }).store(in: &self.cancellables)

        engine.preferenceService.$filters.sink { [weak self] categories in
            self?.updateAnnotations(filters: categories, pins: self?.engine.pinService.pins.responseArray ?? [])
        }.store(in: &self.cancellables)
    }

    func updateAnnotations(filters: [PinCategory], pins: [PinModel]) {
        mapView.removeAnnotations(mapView.annotations)
        let filteredPins = engine.preferenceService.filterPins(filters: filters, pins: pins)
        configureAnnotations(pins: filteredPins)
    }

    func configureCenter() {
        let center = engine.geoLocationService.latestUserLocation?.coordinate ?? UIProperties.Location.parisCenter
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }

    func configureMapView() {
        configureCenter()
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
}

extension PinMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pinAnnotation = view.annotation as? MapItem {
            delegate?.didSelectPin(id: pinAnnotation.id)
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

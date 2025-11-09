//
//  MapAnnotationData.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 9/11/2025.
//


import SwiftUI
import MapKit

// Annotation data (Identifiable + Equatable)
struct MapAnnotationData: Identifiable, Equatable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    static func == (lhs: MapAnnotationData, rhs: MapAnnotationData) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude &&
               lhs.title == rhs.title &&
               lhs.subtitle == rhs.subtitle
    }
}

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D?
    @Binding var annotations: [MapAnnotationData]
    var showsUserLocation: Bool = true
    var followUser: Bool = false
    var zoomLevel: CLLocationDistance = 1000 // meters

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showsUserLocation
        mapView.userTrackingMode = followUser ? .follow : .none
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.mapType = .standard

        // Tap recognizer to add annotations on tap
        let tapGR = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap(_:)))
        tapGR.numberOfTapsRequired = 1
        tapGR.delegate = context.coordinator
        mapView.addGestureRecognizer(tapGR)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Center map when centerCoordinate changes
        if let center = centerCoordinate {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
            uiView.setRegion(region, animated: true)
        }

        // Sync annotations (remove existing non-user annotations and re-add)
        let existing = uiView.annotations.filter { !($0 is MKUserLocation) }
        uiView.removeAnnotations(existing)
        for a in annotations {
            let ann = MKPointAnnotation()
            ann.coordinate = a.coordinate
            ann.title = a.title
            ann.subtitle = a.subtitle
            uiView.addAnnotation(ann)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
            super.init()
        }

        @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let point = gesture.location(in: mapView)
            let coord = mapView.convert(point, toCoordinateFrom: mapView)

            let data = MapAnnotationData(coordinate: coord, title: "Marqueur", subtitle: nil)
            DispatchQueue.main.async {
                self.parent.annotations.append(data)
                self.parent.centerCoordinate = coord
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }

            let id = "pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
                view?.canShowCallout = true
                view?.markerTintColor = UIColor(red: 0.95, green: 0.55, blue: 0.35, alpha: 1.0) // orange
                view?.glyphImage = UIImage(systemName: "mappin.and.ellipse")
                view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                view?.annotation = annotation
            }
            return view
        }
    }
}
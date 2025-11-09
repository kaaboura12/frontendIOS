//
//  LocationView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 9/11/2025.
//


import SwiftUI
import CoreLocation
import MapKit

struct LocationView: View {
    @StateObject private var lm = LocationManager()
    @State private var centerCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 36.8065, longitude: 10.1815) // default Tunis
    @State private var annotations: [MapAnnotationData] = []
    @State private var followUser = false
    @State private var searchText = ""
    @FocusState private var searchFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            // Fullscreen map in background
            MapView(centerCoordinate: $centerCoordinate,
                    annotations: $annotations,
                    showsUserLocation: true,
                    followUser: followUser,
                    zoomLevel: 1000)
                .ignoresSafeArea()

            // Search bar pinned to the very top (above the notch)
            SearchBar(text: $searchText, placeholder: "Search places", onSubmit: {
                performSearch()
            }, onClear: {
                // optional clear handler
            })
            .padding(.horizontal, 16)
            .padding(.top, safeTop() + 8) // pin above notch

            // Bottom area with the "Ma position" button
            VStack {
                Spacer()
                Button(action: centerOnUser) {
                    Text("Ma position")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(colors: [
                                Color(red: 0.98, green: 0.66, blue: 0.45),
                                Color(red: 0.95, green: 0.55, blue: 0.35)
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.35), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, safeBottom() + 10)
            }
        }
        .onAppear {
            lm.requestPermission()
            lm.startUpdating()
        }
        .onChange(of: lm.lastLocation) { loc in
            guard let loc = loc else { return }
            if followUser || centerCoordinate == nil {
                centerCoordinate = loc.coordinate
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Actions

    private func centerOnUser() {
        if let userLoc = lm.lastLocation {
            centerCoordinate = userLoc.coordinate
            followUser = true
        } else {
            lm.requestPermission()
            lm.startUpdating()
        }
    }

    private func performSearch() {
        // placeholder: add MKLocalSearch here if you want search functionality
        print("Search for: \(searchText)")
    }

    // MARK: - Safe area helpers

    private func safeTop() -> CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first
        return (window?.safeAreaInsets.top ?? 44)
    }

    private func safeBottom() -> CGFloat {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first
        return (window?.safeAreaInsets.bottom ?? 0)
    }
}

#Preview {
    LocationView()
}

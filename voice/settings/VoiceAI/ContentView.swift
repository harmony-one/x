//
//  ContentView.swift
//  VoiceAI
//
//  Created by Julia Nai on 10/24/23.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            self.userLocation = location
        }
    }
}

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()

    var body: some View {
        VStack {
            Text(locationManager.userLocation != nil ? "Latitude: \(locationManager.userLocation!.latitude), Longitude: \(locationManager.userLocation!.longitude)" : "Location not available")
                .padding()

            Button("Get Location") {
                // You can manually trigger location updates here if needed.
            }
        }
    }
}

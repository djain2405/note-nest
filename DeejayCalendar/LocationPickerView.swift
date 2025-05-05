//
//  LocationPickerView.swift
//  DeejayCalendar
//
//  Created by Divya Jain on 5/4/25.
//

import Foundation
import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Binding var selectedLocation: String?
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        VStack(spacing: 12) {
            TextField("Search for a place", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal, .top])
                .onChange(of: searchText) { _ in
                    performSearch()
                }

            List(searchResults, id: \.self) { item in
                Button(action: {
                    selectedLocation = item.name
                    dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown")
                            .font(.headline)
                        if let address = item.placemark.title {
                            Text(address)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select a Location")
    }

    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let items = response?.mapItems {
                self.searchResults = items
            }
        }
    }
}

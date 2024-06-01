//
//  WeatherMapViewModel.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
class WeatherMapViewModel: ObservableObject {
// MARK: Published variables
    @Published var weatherDataModel: WeatherDataModel?
    @Published var city = "London"
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    @Published var annotations: [PlaceAnnotation] = []
    init() {
// MARK: Create Task to load London weather data when the app first launches
        Task {
            do {
                try await getCoordinatesForCity()
                let weatherData = try await loadData(lat: coordinates?.latitude ?? 51.503300, lon: coordinates?.longitude ?? -0.079400)
                print("Weather data loaded: \(String(describing: weatherData.timezone))")

            } catch {
                // Handle errors if necessary
                print("Error loading weather data: \(error)")
            }
        }
    }
    func getCoordinatesForCity() async throws {
// MARK:  complete the code to get user coordinates for user entered place
// and specify the map region

        let geocoder = CLGeocoder()
        if let placemarks = try? await geocoder.geocodeAddressString(city),
           let location = placemarks.first?.location?.coordinate {

            DispatchQueue.main.async {
                self.coordinates = location
                self.region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        } else {
            // Handle error here if geocoding fails
            print("Error: Unable to find the coordinates for the city.")
        }
    }

    func loadData(lat: Double, lon: Double) async throws -> WeatherDataModel {
// MARK: Add your appid in the url below:
        let APIKey = "df915ca04045da98541a9ed56d2a144b"
        if let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=\(APIKey)") {
            let session = URLSession(configuration: .default)

            do {
                let (data, _) = try await session.data(from: url)
                let weatherDataModel = try JSONDecoder().decode(WeatherDataModel.self, from: data)

                DispatchQueue.main.async {
                    self.weatherDataModel = weatherDataModel
                    print("weatherDataModel loaded")
                }

                return weatherDataModel
            } catch {
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                } else {
                    print("Error: \(error)")
                }
                throw error
            }
        } else {
            throw NetworkError.invalidURL
        }
    }

    enum NetworkError: Error {
        case invalidURL
    }

    func loadLocationsFromJSONFile(cityName: String) -> [Location]? {
        if let fileURL = Bundle.main.url(forResource: "places", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let allLocations = try decoder.decode([Location].self, from: data)

                return allLocations
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("File not found")
        }
        return nil
    }

    // MARK: Struct for map annotations
    struct PlaceAnnotation: Identifiable {
        let id = UUID()
        let selected: Bool = false
        let name: String
        let location: CLLocationCoordinate2D

        init(name: String, location: CLLocationCoordinate2D) {
            self.name = name
            self.location = location
        }
    }
}



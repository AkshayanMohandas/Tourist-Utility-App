//
//  TouristPlacesMapView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var locations: [Location] = []
    @State var  mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574), latitudinalMeters: 600, longitudinalMeters: 600)
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                if weatherMapViewModel.coordinates != nil {
                    VStack(spacing: 10) {
                        GeometryReader { geometry in
                            Map(coordinateRegion: $mapRegion,
                                showsUserLocation: false,
                                userTrackingMode: .none,
                                annotationItems: weatherMapViewModel.annotations
                            ) { place in
                                MapAnnotation(coordinate: place.location) {
                                    VStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                        Text(place.name)
                                            .font(.footnote)
                                    }
                                }
                            }
                            .edgesIgnoringSafeArea(.all)
                            .frame(height: geometry.size.height * 0.78)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        let delta = (value - 1.0) * 0.02
                                        weatherMapViewModel.region.span.latitudeDelta *= (1.0 + delta)
                                        weatherMapViewModel.region.span.longitudeDelta *= (1.0 + delta)
                                    }
                            )
                        }
                        
                        VStack {
                            Text("Tourist Attractions in \(weatherMapViewModel.city)")
                                .font(.title)
                        }
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, -75)
                    }
                }
                
                List {
                    ForEach(locations) { location in
                        if location.cityName == weatherMapViewModel.city {
                            NavigationLink(destination: DetailView(location: location)) {
                                HStack {
                                    VStack {
                                        HStack {
                                            if let imageName = location.imageNames[safe: 2] ?? location.imageNames.first {
                                                Image(imageName)
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(15)
                                            } else {
                                                Image("defaultImage")
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .cornerRadius(15)
                                            }
                                            Text("\(location.name)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 40.0)
                .padding(.top, -20.0)
                .background(Color.white)
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            // process the loading of tourist places
            self.mapRegion = weatherMapViewModel.region
            mapRegion.span.latitudeDelta = 0.037
            mapRegion.span.longitudeDelta = 0.037
            if let loadedLocations = weatherMapViewModel.loadLocationsFromJSONFile(cityName: weatherMapViewModel.city) {
                self.locations = loadedLocations
                for location in loadedLocations {
                    if location.cityName == weatherMapViewModel.city {
                        let coordinates = CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
                        let place = WeatherMapViewModel.PlaceAnnotation(name: location.name, location: coordinates)
                        weatherMapViewModel.annotations.append(place)
                    }
                }
            } else {
                print("Error loading locations")
            }
        }
    }
}

struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView()
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


struct DetailView: View {
    var location: Location
    
    @State private var isLinkButtonVisible = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(1.0), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Details for \(location.name)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 32)
                    
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(location.imageNames, id: \.self) { imageName in
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width - 32, height: 250)
                                        .cornerRadius(20)
                                        .shadow(color: .black, radius: 10, x: 0, y: 5)
                                }
                            }
                            .padding(16)
                        }
                    }
                    .frame(height: 300)
                    
                    Text(location.description)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if let link = URL(string: location.link) {
                        Button(action: {
                            UIApplication.shared.open(link)
                        }) {
                            Text("Explore More")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                        .opacity(isLinkButtonVisible ? 1 : 0)
                        .offset(y: isLinkButtonVisible ? 0 : 16)
                        .rotationEffect(.degrees(isLinkButtonVisible ? 0 : -5))
                        .onAppear {
                            withAnimation {
                                isLinkButtonVisible = true
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(location.name), displayMode: .inline)
    }
}


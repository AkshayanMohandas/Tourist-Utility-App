//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//


import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var isLoading = false
    @State private var temporaryCity = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        
        ZStack {
            Image("sky")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
                .zIndex(0)
            ScrollView{
                VStack {
                    HStack {
                        Text("Change Location")
                        
                        TextField("Enter New Location", text: $temporaryCity)
                            .focused($focus)
                            .onSubmit {
                                weatherMapViewModel.city = temporaryCity
                                Task {
                                    do {
                                        // write code to process user change of location
                                        try await weatherMapViewModel.getCoordinatesForCity()
                                        _ = try await weatherMapViewModel.loadData(lat: weatherMapViewModel.coordinates?.latitude ?? 51.503300, lon: weatherMapViewModel.coordinates?.longitude ?? -0.079400)
                                    } catch {
                                        print("Error: \(error)")
                                        isLoading = false
                                    }
                                }
                            }
                    }
                    .bold()
                    .font(.system(size: 20))
                    .padding(15)
                    .shadow(color: .blue, radius: 10)
                    .cornerRadius(10)
                    .fixedSize()
                    .font(.custom("Arial", size: 26))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(15)
                    HStack {
                        Text("Current Location: \(weatherMapViewModel.city)")
                            .bold()
                            .font(.system(size: 20))
                            .padding(10)
                            .shadow(color: .blue, radius: 10)
                            .cornerRadius(10)
                            .fixedSize()
                            .font(.custom("Arial", size: 26))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(15)
                    }
                    VStack {
                        // Weather Temperature Value
                        if let forecast = weatherMapViewModel.weatherDataModel {
                            VStack(spacing: 0) {
                                let timestamp = TimeInterval(forecast.current.dt)
                                let formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp)
                                Text(formattedDate)
                                    .padding()
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .shadow(color: .black, radius: 1)
                                HStack {
                                    VStack(spacing: 20) {
                                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(forecast.current.weather[0].icon)@2x.png")) { image in
                                            image.resizable()
                                        } placeholder: { }
                                            .frame(width: 50, height: 50)
                                        
                                        Image("temperature")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        
                                        Image("humidity")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        
                                        Image("pressure")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        
                                        Image("windSpeed")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                    VStack(spacing: 0) {
                                        Text(forecast.current.weather[0].weatherDescription.rawValue.capitalized)
                                            .font(.system(size: 25, weight: .bold))
                                            .padding()
                                        
                                        Text("Temp: \(String(format: "%.2f", forecast.current.temp)) ºC")
                                            .font(.system(size: 25, weight: .bold))
                                            .padding()
                                        
                                        Text("Humidity: \(forecast.current.humidity) %")
                                            .font(.system(size: 25, weight: .bold))
                                            .padding()
                                        
                                        Text("Pressure: \(forecast.current.pressure) hPa")
                                            .font(.system(size: 25, weight: .bold))
                                            .padding()
                                        
                                        Text("Windspeed: \(Int(forecast.current.windSpeed)) mph")
                                            .font(.system(size: 25, weight: .bold))
                                            .padding()
                                    }
                                }.padding(40)
                                Spacer()
                            }
                        } else {
                            VStack (spacing: 20){
                                Text("N/A")
                                    .font(.system(size: 25, weight: .medium))
                                
                                Text("Temp: N/A")
                                    .font(.system(size: 25, weight: .medium))
                                
                                Text("Humidity: N/A")
                                    .font(.system(size: 25, weight: .medium))
                                
                                Text("Pressure: N/A")
                                    .font(.system(size: 25, weight: .medium))
                                
                                Text("Windspeed: N/A")
                                    .font(.system(size: 25, weight: .medium))
                            }
                        }
                        Spacer()
                    }
                }
            }.padding(.top, 30)
        }
        .navigationBarHidden(true)
        .onTapGesture {
            focus = false
        }
    }
}

struct WeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNowView()
    }
}

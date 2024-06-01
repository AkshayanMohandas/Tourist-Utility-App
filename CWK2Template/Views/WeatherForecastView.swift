//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var body: some View {
        NavigationView {
            ZStack {
                Image("appBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .padding(.horizontal, 16)
                VStack(alignment: .leading, spacing: 16) {
                    if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 10) {
                                
                                ForEach(hourlyData) { hour in
                                    HourWeatherView(current: hour)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 180)
                    }
                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    VStack {
                        List {
                            ForEach(weatherMapViewModel.weatherDataModel?.daily ?? []) { day in
                                DailyWeatherView(day: day)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .background(
                                        Image("background")
                                            .resizable()
                                            .frame(alignment: .bottomLeading)
                                            .opacity(0.2)
                                    ).padding(.horizontal)
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .frame(height: 525)
                        // .opacity(0.2)
                    }
                }
                .padding(.horizontal, 16)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image(systemName: "sun.min.fill")
                            VStack {
                                Text("Weather Forecast for \(weatherMapViewModel.city)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView()
    }
}

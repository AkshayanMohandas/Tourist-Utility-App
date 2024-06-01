//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    var current: Current
    
    var body: some View {
        let formattedDate = DateFormatterUtils.formattedDateWithDay(from: TimeInterval(current.dt))
        VStack(alignment: .center, spacing: 5) {
            Text(formattedDate)
                .font(.body)
            
                .padding(.horizontal)
                .foregroundColor(.black)
                .padding([.top], 25)
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(current.weather[0].icon)@2x.png")) { image in
                image.resizable()
            } placeholder: {  }
                .frame(width: 50, height: 50)
            
            Text("\(Int(current.temp)) °C")
                .frame(width: 125)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.horizontal)
                .foregroundColor(.black)
            
            Text(current.weather[0].weatherDescription.rawValue)
                .frame(width: 125)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.horizontal)
                .foregroundColor(.black)
                .padding([.bottom],25)
            
        }
        .background(Color.teal)
        .cornerRadius(15)
        .shadow(radius: 5)
        
    }
}








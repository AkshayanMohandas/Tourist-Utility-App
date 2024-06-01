//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    var day: Daily
    var body: some View {
        
        HStack{
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(day.weather[0].icon)@2x.png")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
            } placeholder: {  }
            
            Spacer()
            
            let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt))
            
            VStack {
                Text(day.weather[0].weatherDescription.rawValue)
                    .font(.body)
                
                Text(formattedDate)
                    .font(.body) // Customize the font if needed
            }
            
            Spacer()
            
            Text("\(Int(day.temp.max))°C / \(Int(day.temp.min))°C")
                .font(.body)
                .multilineTextAlignment(.trailing)
            
        }
        
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var day = WeatherMapViewModel().weatherDataModel!.daily
    static var previews: some View {
        DailyWeatherView(day: day[0])
    }
}



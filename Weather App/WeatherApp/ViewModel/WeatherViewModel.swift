//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 27.11.2023.
//

import Foundation
import CoreData

//Main ViewModel for Weather
class WeatherViewModel {
    let weatherData: WeatherData
    let forecastList: [List]
    let hourlyForecast: [List]
    
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        self.forecastList = weatherData.list
        self.hourlyForecast = Array(forecastList.prefix(8))
    }
    
    func topWeatherTemperature() -> Double {
        return forecastList.first?.main.temp ?? 0.0
    }
    
    func DailyForecast(){
        let currentDate = Date()
        let calendar = Calendar.current
        let dailyForecast: [List] = forecastList
        var day:Int = 0
        var hour:Int = 0
        var tempDay:Double = 0.0
        var tempNight:Double = 0.0
        
        for items in dailyForecast{
            switch formateDate(dateString: items.dt_txt){
            case .success(let result):
                day = result.day
                hour = result.hour
            case .failure(_):
                print("error")
            }
        }
            
            
    }
        
}
    
    



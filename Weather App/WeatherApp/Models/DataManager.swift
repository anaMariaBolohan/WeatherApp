//
//  DataManager.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 28.11.2023.
//

import Foundation
import UIKit


extension WeatherViewController: WeatherManagerDelegate{
    
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherViewModel) {
        DispatchQueue.main.async {
            // Update Hourly View and Daily Forecast
            self.hourlyView.updateWeatherDataForNext24Hours(with: weather.weatherData)
            self.dailyForecast.updateForecasts(with: weather.weatherData)

            // Update Wind Information
            self.updateWeatherUnit(for: self.Wind, imageName: "location.fill", unitName: "Wind", unitValue: String(format: "%.1f km/h", weather.forecastList[0].wind.speed))

            // Update Chance of Rain Information
            self.updateWeatherUnit(for: self.Rain, imageName: "cloud.rain", unitName: "Chance of rain", unitValue: String(format: "%.1f%%", weather.forecastList[0].pop))

            // Update Pressure Information
            self.updateWeatherUnit(for: self.Pressure, imageName: "thermometer.medium", unitName: "Pressure", unitValue: String(format: "%.0f mbar", weather.forecastList[0].main.pressure))

            // Update Humidity Information
            self.updateWeatherUnit(for: self.Humidity, imageName: "drop.degreesign", unitName: "Humidity", unitValue: "\(weather.forecastList[0].main.humidity)%")

            // Update Current Date Information
            switch getDateForLabel(dateString: weather.forecastList[0].dt_txt) {
            case .success(let result):
                self.currentDate.dayNameLabel.text = result.dayName
                self.currentDate.currentMonthAndDay.text = "\(result.month) \(result.day)"
            case .failure(_):
                print("error")
            }

            // Update Top Temperature Text
            self.TopTemperature.text = String(format: "%.0f °", weather.forecastList[0].main.temp)
            
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func updateWeatherUnit(for unit: StatusDisplay, imageName: String, unitName: String, unitValue: String) {
        unit.unitImage.image = UIImage(systemName: imageName)
        unit.unitName.text = unitName
        unit.unit.text = unitValue
    }
}

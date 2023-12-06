//
//  NetworkLayer.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 27.11.2023.
//
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherViewModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=cf042cb490b3f4314a70e39cb6535ce0"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String, unit: String) {
            let urlString = "\(weatherURL)&q=\(cityName)&units=\(unit)"
            performRequest(with: urlString)
        }
    func performRequest(with urlString: String) {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            UserDefaults.standard.set(String(data: safeData, encoding: .utf8), forKey: "weatherJSON")
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
                task.resume()
            }
        }
    func parseJSON(_ weatherData: Data) -> WeatherViewModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let weatherData = decodedData
                
                let weather = WeatherViewModel(weatherData: weatherData)
                return weather
                
            } catch {
                delegate?.didFailWithError(error: error)
                print(error)
                return nil
            }
        }
}

//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 27.11.2023.
//

import Foundation

//Weather info for specific time
struct WeatherData: Codable{
    let city: City
    let list: [List]
}
//Detailed weather information which includes wind speed, pressure and humidity

struct City:Codable {
    let name: String
    
}

struct Main:Codable{
    
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Int
    
}
struct WeatherDescription:Codable{
    let id: Int
    let description: String
}
struct Wind:Codable{
    let speed: Double
}
struct List:Codable{
    let pop: Double
    let dt_txt: String
    let dt: TimeInterval
    let main: Main
    let weather: [WeatherDescription]
    let wind: Wind
}

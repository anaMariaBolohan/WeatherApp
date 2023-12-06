//
//  FormatDate.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 28.11.2023.
//

import Foundation

enum DateError: Error{
    case invalidFormat
}
func getCurrentTime() -> String {
    let currentDate = Date()

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E | d MMM" // Adjust the format as needed

    let currentTimeString = dateFormatter.string(from: currentDate)

    return currentTimeString
}

func formateDate(dateString: String)->Result<(day:Int, hour:Int), DateError>{
    
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = dateFormater.date(from: dateString){
        let calendar = Calendar.current
        let dayComponent = calendar.component(.day, from: date)
        let hourComponent = calendar.component(.hour, from: date)
        return .success((day:dayComponent, hour:hourComponent))
    }else{
        return .failure(.invalidFormat)
        
    }
}

    
func getDateForLabel(dateString: String)->Result<(day:Int, month:String, dayName:String), DateError>{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormater.date(from: dateString){
            let calendar = Calendar.current
            let dayComponent = calendar.component(.day, from: date)
            dateFormater.dateFormat = "MMM"
            let monthComponent = dateFormater.string(from: date)
            dateFormater.dateFormat = "EEE"
            let dayName = dateFormater.string(from: date)
            return .success((day:dayComponent, month:monthComponent, dayName: dayName))
        }else{
            return .failure(.invalidFormat)
        }
    }


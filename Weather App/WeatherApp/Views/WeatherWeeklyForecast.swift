//
//  WeatherWeeklyForecast.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 05.12.2023.
//

import Foundation

import UIKit

// Define the model for daily forecast
struct DailyForecast {
    let date: Date
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    let weatherSymbolName: String // This is the SF Symbol name
    let rainChance: String
    let temperatureRange: String
}

// Define the custom UICollectionViewCell
class DailyWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "DailyWeatherCollectionViewCell"
    
    // UI Elements
    private let dayLabel = UILabel()
    private let weatherImageView = UIImageView()
    private let rainChanceLabel = UILabel()
    private let temperatureRangeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        dayLabel.font = .systemFont(ofSize: 14, weight: .medium)
        rainChanceLabel.font = .systemFont(ofSize: 14, weight: .regular)
        temperatureRangeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        // Weather Image View Configuration
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.tintColor = .white
        
        // Add subviews
        [dayLabel, weatherImageView, rainChanceLabel, temperatureRangeLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            weatherImageView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -25),
            weatherImageView.widthAnchor.constraint(equalToConstant: 25),
            weatherImageView.heightAnchor.constraint(equalToConstant: 25),
            
            rainChanceLabel.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            rainChanceLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            
            temperatureRangeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            temperatureRangeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    func configure(with forecast: DailyForecast) {
        dayLabel.text = forecast.day
        weatherImageView.image = UIImage(systemName: forecast.weatherSymbolName)
        rainChanceLabel.text = forecast.rainChance
        temperatureRangeLabel.text = forecast.temperatureRange
    }
}

// Custom UIView containing the UICollectionView
class WeeklyForecastView: UIView {
    private let collectionView: UICollectionView
    private var forecasts: [DailyForecast] = [] // This array will be populated with forecast data
    private let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        headerLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headerLabel.text = "Forecasts for 5 Days"
        headerLabel.textAlignment = .left
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15), // Adjust constant for space from the top
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // Adjust constant for space from the left
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16) // Adjust constant for space from the right
        ])
        
        collectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateForecasts(with weatherData: WeatherData) {
        // group by day and extract min/max temperatures
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: weatherData.list, by: { (element: List) -> Date in
            let date = Date(timeIntervalSince1970: element.dt)
            return calendar.startOfDay(for: date)
        })
        
        // Map the grouped data to DailyForecast, calculating min/max temperatures for each day
        forecasts = groupedByDay.compactMap { (key, value) -> DailyForecast? in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE" // Day of the week
            let day = dateFormatter.string(from: key)
            
            let minTemp = value.min(by: { $0.main.temp_min < $1.main.temp_min })?.main.temp_min ?? 0
            let maxTemp = value.max(by: { $0.main.temp_max < $1.main.temp_max })?.main.temp_max ?? 0
            let rainChance = Int((value.max(by: { $0.pop < $1.pop })?.pop ?? 0) * 100)
            
            // Assuming the first weather condition of each group is representative for the day
            let weatherSymbolName = getSymbolName(from: value.first?.weather.first?.id ?? 0)
            
            return DailyForecast(
                date: Date(timeIntervalSince1970: value.first!.dt),
                weatherSymbolName: weatherSymbolName,
                rainChance: "\(rainChance)% rain",
                temperatureRange: "\(Int(minTemp))°/\(Int(maxTemp))°"
            )
        }
        .sorted(by: { $0.date < $1.date }) // Sort by day
        
        collectionView.reloadData()
    }
    
    
    private func getSymbolName(from weatherConditionId: Int) -> String {
        
        switch weatherConditionId {
            case 200...232: return "cloud.bolt.rain.fill" // Thunderstorm
            case 300...321: return "cloud.drizzle.fill" // Drizzle
            case 500...531: return "cloud.rain.fill" // Rain
            case 600...622: return "cloud.snow.fill" // Snow
            case 701...781: return "cloud.fog.fill" // Fog
            case 800: return "sun.max.fill" // Clear sky
            case 801...804: return "cloud.fill" // Cloudy
            default: return "questionmark.diamond.fill"
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WeeklyForecastView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.identifier, for: indexPath) as? DailyWeatherCollectionViewCell else {
            fatalError("Unable to dequeue DailyWeatherCollectionViewCell")
        }
        let forecast = forecasts[indexPath.row]
        cell.configure(with: forecast)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 20, height: 30)
    }
}

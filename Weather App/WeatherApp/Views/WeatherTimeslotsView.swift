//
//  WeatherTimeslotsView.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 05.12.2023.
//

import Foundation
import UIKit

struct WeatherTimeSlot {
    let time: String
    let temperature: String
    let rainChance: String
    let weatherSymbolName: String // This is the SF Symbol name
    
    // Formatter for the date text
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Adjust the format as needed for your UI
        return formatter
    }()
    
    // Initializer that maps the OpenWeather API data to the WeatherTimeSlot
    init(from list: List) {
        // Convert the date from UNIX format to a human-readable string
        let date = Date(timeIntervalSince1970: list.dt)
        self.time = WeatherTimeSlot.dateFormatter.string(from: date)
        
        // Format the temperature to be a string with no decimal places
        self.temperature = "\(Int(list.main.temp))°"
        
        // Convert the probability of precipitation to a percentage string
        self.rainChance = "\(Int(list.pop * 100))% rain"
        
        // Map the weather condition codes to SF Symbols
        self.weatherSymbolName = WeatherTimeSlot.getSymbolName(for: list.weather.first?.id ?? 0)
    }
    
    // A function to map weather condition codes to SF Symbol names
    static func getSymbolName(for weatherConditionId: Int) -> String {
        // The weather condition codes are documented by OpenWeather
        // You would map them to SF Symbols based on their meaning
        // For example:
        switch weatherConditionId {
            case 200...232:
                return "cloud.bolt.rain.fill" // Thunderstorm
            case 300...321:
                return "cloud.drizzle.fill" // Drizzle
            case 500...531:
                return "cloud.rain.fill" // Rain
            case 600...622:
                return "cloud.snow.fill" // Snow
            case 701...781:
                return "cloud.fog.fill" // Atmosphere
            case 800:
                return "sun.max.fill" // Clear
            case 801...804:
                return "cloud.fill" // Clouds
            default:
                return "questionmark" // Unknown weather condition
        }
    }
}

// Define the Weather Collection View Cell
class WeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeatherCollectionViewCell"
    
    // UI elements
    private let timeLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let rainChanceLabel = UILabel()
    private let weatherImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textAlignment = .center
        
        temperatureLabel.font = UIFont.systemFont(ofSize: 16)
        temperatureLabel.textAlignment = .center
        
        rainChanceLabel.font = UIFont.systemFont(ofSize: 12)
        rainChanceLabel.textAlignment = .center
        
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.tintColor = .white
        
        // Add subviews
        [timeLabel, temperatureLabel, rainChanceLabel, weatherImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 20),
            weatherImageView.heightAnchor.constraint(equalToConstant: 20),
            temperatureLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 5),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rainChanceLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5),
            rainChanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rainChanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with weatherTimeSlot: WeatherTimeSlot) {
        timeLabel.text = weatherTimeSlot.time
        temperatureLabel.text = weatherTimeSlot.temperature
        rainChanceLabel.text = weatherTimeSlot.rainChance
        weatherImageView.image = UIImage(systemName: weatherTimeSlot.weatherSymbolName)
    }
}

// Custom UIView containing the UICollectionView
class WeatherView: UIView {
    private let collectionView: UICollectionView
    private let dateLabel: UILabel = UILabel()

    var weatherTimeSlots: [WeatherTimeSlot] = []
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 100)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 100)
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        dateLabel.textAlignment = .left
        dateLabel.text = getCurrentTime()
        
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
                                                
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    
    
    func updateWeatherDataForNext24Hours(with weatherData: WeatherData) {
        let currentTime = Date().timeIntervalSince1970
        let endTime = currentTime + 24 * 60 * 60
        let next24HourData = weatherData.list.filter { $0.dt <= endTime }
        weatherTimeSlots = next24HourData.map { WeatherTimeSlot(from: $0) }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherTimeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as? WeatherCollectionViewCell else {
            fatalError("Unable to dequeue WeatherCollectionViewCell")
        }
        let weatherTimeSlot = weatherTimeSlots[indexPath.row]
        cell.configure(with: weatherTimeSlot)
        return cell
    }
}

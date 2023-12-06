//
//  hourlyView.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 28.11.2023.
//

import UIKit
@IBDesignable
final class HourlyPanel: UIView {
    
    @IBOutlet weak var currentDate: DateView!
    
    @IBOutlet weak var hourZero: WeatherByHour!
    
    @IBOutlet weak var hourOne: WeatherByHour!
    
    
    @IBOutlet weak var hourTwo: WeatherByHour!
    
    @IBOutlet weak var hourThree: WeatherByHour!
    
    @IBOutlet weak var hourFour: WeatherByHour!
    
    @IBOutlet weak var hourFive: WeatherByHour!
    
    @IBOutlet weak var hourSix: WeatherByHour!
    
    @IBOutlet weak var hourSeven
    : WeatherByHour!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }

    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "HourlyPanel") else {return}
        view.frame = self.bounds
        self.addSubview(view)
    }
}

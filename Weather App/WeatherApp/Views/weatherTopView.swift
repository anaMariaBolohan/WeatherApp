//
//  weatherTopView.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 23.11.2023.
//

import UIKit
@IBDesignable
class weatherTopView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.configureView()
        }

        private func configureView() {
            guard let view = self.loadViewFromNib(nibName: "weatherTopView") else {return}
            view.frame = self.bounds
            self.addSubview(view)
        }
}

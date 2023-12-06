//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 24.11.2023.
//

import Foundation
import UIKit

extension UIView{
    
    func loadViewFromNib(nibName: String)->UIView?{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
    
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}

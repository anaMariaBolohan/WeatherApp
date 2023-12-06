//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 05.12.2023.
//

import Foundation
import UIKit

protocol searchCity: AnyObject{
    func didSearch(text: String)
}

class CityViewController: UIViewController {
    
    @IBOutlet weak var textBarSearch: UITextField!
    @IBAction func BackToRoot(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    weak var delegate: searchCity?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize your modal view controller here
    }

    // Add any additional code, IBActions, etc., as needed
}

extension CityViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
            textBarSearch.endEditing(true)
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textBarSearch.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            
            if let city = textBarSearch.text {
                delegate?.didSearch(text: city)
            }
            
            textBarSearch.text = ""
            
        }
}


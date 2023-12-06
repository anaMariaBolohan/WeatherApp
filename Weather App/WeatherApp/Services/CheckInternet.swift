//
//  CheckInternet.swift
//  WeatherApp
//
//  Created by Eduard Zepciuc on 28.11.2023.
//

import Foundation
import Network

class NetworkManager {
    static let shared = NetworkManager()

    private let monitor = NWPathMonitor()

    var isInternetAvailable: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isInternetAvailable = path.status == .satisfied
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}


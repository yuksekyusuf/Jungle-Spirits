//
//  NetworkMonitor.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 25.05.2024.
//

import Foundation
import Network

protocol NetworkMonitorDelegate: AnyObject {
    func didRestoreConnection()
}

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = true
    weak var delegate: NetworkMonitorDelegate?

    
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                self.isConnected = isConnected
                if isConnected {
                    self.delegate?.didRestoreConnection()
                }
            }
        }
        monitor.start(queue: queue)
    }
}

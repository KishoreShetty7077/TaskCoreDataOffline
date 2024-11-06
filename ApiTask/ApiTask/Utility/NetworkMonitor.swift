//
//  NetworkMonitor.swift
//  ApiCall
//
//  Created by Kishore B on 11/7/24.
//

import Network

class Connectivity {
    static var isConnectedToInternetMock: Bool? = nil
    private static let monitor = NWPathMonitor()
    private static var isConnected: Bool = false
    private static var isMonitoring = false

    class func startMonitoring(completion: ((Bool) -> Void)? = nil) {
        guard !isMonitoring else {
            completion?(isConnected)
            return
        }

        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            completion?(isConnected)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        isMonitoring = true
    }

    class func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }

    class func isConnectedToInternet() -> Bool {
        return isConnectedToInternetMock ?? isConnected
    }
}

final class ConnectivityManager: ConnectivityService {
    func startMonitoring(completion: @escaping (Bool) -> Void) {
        Connectivity.startMonitoring { isConnected in
            completion(isConnected)
        }
    }
}

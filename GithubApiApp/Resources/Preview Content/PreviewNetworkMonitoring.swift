//
//  PreviewNetworkMonitoring.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import NetworkMonitoring
import Combine

final class PreviewNetworkMonitoring: NetworkMonitorService {
    var isConnected = CurrentValueSubject<Bool, Never>(false)
    
    var currentConnectionStatus: AnyPublisher<Bool, Never> {
        return isConnected.eraseToAnyPublisher()
    }
}

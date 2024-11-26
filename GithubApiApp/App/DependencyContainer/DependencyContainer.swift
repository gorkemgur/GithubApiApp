//
//  DependencyContainer.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import NetworkMonitoring

final class DependencyContainer {
    let networkService: NetworkService
    let localStorageService: LocalStorageService
    let networkMonitoringService: NetworkMonitorService
    
    init(
        networkService: NetworkService = NetworkManager(),
        localStorageService: LocalStorageService = LocalStorageManager(),
        networkMonitoringService: NetworkMonitorService = NetworkMonitoringManager()) {
        self.networkService = networkService
        self.localStorageService = localStorageService
        self.networkMonitoringService = networkMonitoringService
    }
}

extension DependencyContainer {
    static func createContainerForPreview() -> DependencyContainer {
        return .init(
            networkService: PreviewNetworManager(),
            localStorageService: PreviewLocalStorageManager(),
            networkMonitoringService: PreviewNetworkMonitoring()
        )
    }
}

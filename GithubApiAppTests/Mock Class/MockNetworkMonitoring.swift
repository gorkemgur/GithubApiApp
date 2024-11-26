//
//  MockNetworkMonitoring.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 26.11.2024.
//

import Foundation
import NetworkMonitoring
import Combine

@testable import GithubApiApp

final class MockNetworkMonitoring: NetworkMonitorService {
    @Published var isNetworkConnectionAvailable = false
    
    var currentConnectionStatus: AnyPublisher<Bool, Never> {
        $isNetworkConnectionAvailable.eraseToAnyPublisher()
    }
}

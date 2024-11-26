//
//  MockNetworkManager.swift
//  GithubApiAppTests
//
//  Created by Görkem Gür on 26.11.2024.
//

import Foundation
@testable import GithubApiApp

final class MockNetworkManager: NetworkService {
    var shouldShowError: Bool = false
    var didRateLimitExceeded: Bool = false
    var mockData: Data?
    
    func performRequest<T: Decodable>(_ type: T.Type, with endpoint: any Endpoint) async throws -> T {
        
        if shouldShowError {
            throw NetworkError.failedResponse(statusCode: -1)
        }
        
        if didRateLimitExceeded {
            throw NetworkError.rateLimitExceeded
        }
        
        guard let urlRequest = endpoint.createURLRequest() else {
            throw NetworkError.invalidURL
        }
        
        guard let mockData = mockData else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let simulatedDecodedResponse = try JSONDecoder().decode(type, from: mockData)
            return simulatedDecodedResponse
        } catch {
            throw NetworkError.decodeFailed(errorDescription: error.localizedDescription)
        }
    }
}

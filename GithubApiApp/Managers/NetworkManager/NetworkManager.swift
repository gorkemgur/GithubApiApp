//
//  NetworkManager.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

fileprivate enum ResponeHeaderConstants {
    static let rateLimitConstant = "x-ratelimit-remaining"
}

protocol NetworkService: AnyObject {
    func performRequest<T: Decodable>(_ type: T.Type, with endpoint: Endpoint) async throws -> T
}

final class NetworkManager: NetworkService {
    private let urlSession: URLSession
    
    private lazy var jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func performRequest<T: Decodable>(_ type: T.Type, with endpoint: any Endpoint) async throws -> T {
        guard let url = endpoint.createURLRequest() else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let remainingLimit = httpResponse.value(forHTTPHeaderField: ResponeHeaderConstants.rateLimitConstant),
               let remainingLimitValue = Int(remainingLimit) {
                if remainingLimitValue == 0 {
                    throw NetworkError.rateLimitExceeded
                }
            }
            throw NetworkError.failedResponse(statusCode: httpResponse.statusCode)
        }
        do {
            let decodedResponse = try jsonDecoder.decode(type, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodeFailed(errorDescription: error.localizedDescription)
        }
    }
}

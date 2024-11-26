//
//  PreviewNetworManager.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

final class PreviewNetworManager: NetworkService {
    func performRequest<T: Decodable>(_ type: T.Type, with endpoint: any Endpoint) async throws -> T  {
        return try JSONDecoder().decode(T.self, from: "{}".data(using: .utf8)!)
    }
}

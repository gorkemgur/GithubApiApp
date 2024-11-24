//
//  NetworkError.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case failedResponse(statusCode: Int)
    case rateLimitExceeded
    case decodeFailed(errorDescription: String)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            "Invalıd URL Error Check Your URL"
        case .invalidResponse:
            "Invalid Response Check Your Request"
        case .failedResponse(let statusCode):
            "Failed Response With StatusCode:\(statusCode)"
        case .rateLimitExceeded:
            "Rate Limit Exceeded You Can Try Again In 1-2 hours"
        case .decodeFailed(let decodeErrorDescription):
            "Decode Failed With DecodeError: \n\(decodeErrorDescription)\n"
        }
    }
}

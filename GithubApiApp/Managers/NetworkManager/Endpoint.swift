//
//  Endpoint.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var headers: [String: String] { get }
    var scheme: String { get }
}


enum HTTPMethod: String {
    case get = "GET"
    case delete = "DELETE"
    case post = "POST"
    case put = "PUT"
}


extension Endpoint {
    var baseURL: String {
        AppConfiguration.baseURL
    }
    
    var scheme: String {
        "https"
    }
    
    var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func createURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.path = path
        urlComponents.host = baseURL
        
        if let queryParameters = queryParameters {
            urlComponents.queryItems = queryParameters.compactMap { queryParameter in
                return URLQueryItem(name: queryParameter.key, value: queryParameter.value)
            }
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = httpMethod.rawValue
        requestURL.allHTTPHeaderFields = headers
        
        return requestURL
    }
}

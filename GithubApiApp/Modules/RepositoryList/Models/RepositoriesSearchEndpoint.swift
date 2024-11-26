//
//  RepositoriesSearchEndpoint.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

enum RepositoriesSearchEndpoint: Endpoint {
    case getRepositories(userName: String, page: Int, perPage: Int)
    var path: String {
        switch self {
        case .getRepositories(let userName, _, _):
            "/users/\(userName)/repos"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getRepositories(_, let page, let perPage):
            [
                "type": "owner",
                "page": "\(page)",
                "per_page": "\(perPage)"
            ]
        }
    }
}

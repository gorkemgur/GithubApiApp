//
//  UserSearchEndpoint.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

enum UserSearchEndpoint: Endpoint {
    case searchUser(userName: String)
    
    var path: String {
        switch self {
        case .searchUser(let userName):
            "/users/\(userName)"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}

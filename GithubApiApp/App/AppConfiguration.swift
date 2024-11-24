//
//  AppConfiguration.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

enum AppConfiguration {
    fileprivate enum Keys {
        static let baseURL = "BASE_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist is missing!")
        }
        return infoDictionary
    }()
    
    static var baseURL: String {
        guard let baseURL = infoDictionary[Keys.baseURL] as? String else {
            return ""
        }
        return baseURL
    }
}


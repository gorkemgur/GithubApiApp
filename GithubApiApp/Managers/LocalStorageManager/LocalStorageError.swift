//
//  LocalStorageError.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

enum LocalStorageError: LocalizedError {
    case saveError(Error)
    case fetchError(Error)
    
    var errorDescription: String {
        switch self {
        case .saveError(let error):
            return "Error Ocurred With Saving Data \(error.localizedDescription)"
        case .fetchError(let error):
            return "Error Ocurred With Fetching Data \(error.localizedDescription)"
        }
    }
}

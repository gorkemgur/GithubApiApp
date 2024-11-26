//
//  LocalStorageError.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation

enum LocalStorageError: LocalizedError, Equatable {
    case saveError(String)
    case fetchError
    case userNotFoundError
    case repositoryNotFoundError
    
    var errorDescription: String {
        switch self {
        case .saveError(let errorDescription):
            return "Error Ocurred With Saving Data \(errorDescription)"
        case .fetchError:
            return "Error Ocurred With Fetching Data"
        case .userNotFoundError:
            return "Error Ocurred User Not Found"
        case .repositoryNotFoundError:
            return "Repository Not Found Error"
        }
    }
}

//
//  storageFilterOptions.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import RealmSwift

enum StorageFilterOptions {
    case user(userName: String)
    case repositories(ownerId: Int)
    
    var fetchRequest: NSPredicate {
        switch self {
        case .user(let userName):
            return NSPredicate(format: "login CONTAINS[c] %@", userName)
        case .repositories(let ownerId):
            return NSPredicate(format: "id == %@", NSNumber(value: ownerId))
        }
    }
}

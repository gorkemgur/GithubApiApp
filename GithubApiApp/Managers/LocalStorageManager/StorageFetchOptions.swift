//
//  StorageFetchOptions.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import RealmSwift

enum StorageFetchOptions {
    case user(userName: String)
    
    var fetchRequest: NSPredicate {
        switch self {
        case .user(let userName):
            return NSPredicate(format: "login CONTAINS[c] %@", userName)
        }
    }
}

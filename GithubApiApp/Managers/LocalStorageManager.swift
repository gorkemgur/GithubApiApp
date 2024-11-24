//
//  LocalStorageManager.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import Foundation
import RealmSwift

protocol LocalStorageService: AnyObject {
    
}

final class LocalStorageManager: LocalStorageService {
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
}
